package com.smarthealth.service;

import com.smarthealth.model.*;
import com.smarthealth.repository.jpa.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class ReminderService {

    @Autowired
    private ReminderRepository reminderRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private PrescriptionRepository prescriptionRepository;

    @Autowired
    private EmailService emailService;

    // Run every minute at 0 seconds
    @Scheduled(cron = "0 * * * * *")
    @Transactional
    public void processReminders() {
        LocalTime nowTime = LocalTime.now().withSecond(0).withNano(0);
        LocalDate nowDate = LocalDate.now();

        // 1. Process Custom Reminders
        try {
            List<Reminder> activeReminders = reminderRepository.findAll();
            
            for (Reminder reminder : activeReminders) {
                if (!Boolean.TRUE.equals(reminder.getIsActive())) continue;
                
                if (reminder.getReminderTime() == null || 
                    reminder.getReminderTime().getHour() != nowTime.getHour() || 
                    reminder.getReminderTime().getMinute() != nowTime.getMinute()) {
                    continue;
                }

                boolean shouldSend = false;
                if ("ONE_TIME".equalsIgnoreCase(reminder.getType())) {
                    if (reminder.getReminderDate() != null && reminder.getReminderDate().equals(nowDate)) {
                        shouldSend = true;
                        // Mark as inactive after sending one-time
                        reminder.setIsActive(false);
                        reminderRepository.save(reminder);
                    }
                } else if ("DAILY".equalsIgnoreCase(reminder.getType())) {
                    shouldSend = true;
                }

                if (shouldSend) {
                    emailService.sendReminderEmail(
                            reminder.getPatient().getUser().getEmail(),
                            reminder.getPatient().getUser().getFullName(),
                            reminder.getTitle(),
                            reminder.getDescription() != null ? reminder.getDescription() : "Friendly health reminder!"
                    );
                }
            }
        } catch (Exception e) {
            System.err.println("Error processing custom reminders: " + e.getMessage());
            e.printStackTrace();
        }

        // 2. Process Medicine Reminders
        try {
            List<Patient> patients = patientRepository.findAll();
            System.out.println("[MedReminder] Checking " + patients.size() + " patients at " + nowTime);
            
            for (Patient patient : patients) {
                if (!Boolean.TRUE.equals(patient.getMedicineRemindersEnabled())) {
                    System.out.println("[MedReminder] Patient #" + patient.getId() + " (" + patient.getUser().getFullName() + ") - DISABLED");
                    continue;
                }

                System.out.println("[MedReminder] Patient #" + patient.getId() + " (" + patient.getUser().getFullName() + ") - ENABLED");
                System.out.println("[MedReminder]   Times: M=" + patient.getMorningReminderTime() + " A=" + patient.getAfternoonReminderTime() + " N=" + patient.getNightReminderTime());

                boolean isMorning = patient.getMorningReminderTime() != null && 
                                    nowTime.getHour() == patient.getMorningReminderTime().getHour() && 
                                    nowTime.getMinute() == patient.getMorningReminderTime().getMinute();
                
                boolean isAfternoon = patient.getAfternoonReminderTime() != null && 
                                      nowTime.getHour() == patient.getAfternoonReminderTime().getHour() && 
                                      nowTime.getMinute() == patient.getAfternoonReminderTime().getMinute();
                
                boolean isNight = patient.getNightReminderTime() != null && 
                                  nowTime.getHour() == patient.getNightReminderTime().getHour() && 
                                  nowTime.getMinute() == patient.getNightReminderTime().getMinute();

                System.out.println("[MedReminder]   Match: isMorning=" + isMorning + " isAfternoon=" + isAfternoon + " isNight=" + isNight);

                if (!isMorning && !isAfternoon && !isNight) {
                    continue;
                }

                List<Prescription> activePrescriptions = getActivePrescriptions(patient, nowDate);
                System.out.println("[MedReminder]   Active prescriptions: " + activePrescriptions.size());
                if (activePrescriptions.isEmpty()) {
                    continue;
                }

                List<String> medicinesToTake = new ArrayList<>();

                for (Prescription prescription : activePrescriptions) {
                    List<PrescribedMedicine> meds = prescription.getPrescribedMedicinesList();
                    System.out.println("[MedReminder]   Rx #" + prescription.getId() + " has " + (meds != null ? meds.size() : 0) + " medicines");
                    if (meds != null) {
                        for (PrescribedMedicine pm : meds) {
                            boolean match = shouldTakeMedicineNow(pm.getTiming(), isMorning, isAfternoon, isNight);
                            System.out.println("[MedReminder]     " + pm.getMedicineName() + " timing='" + pm.getTiming() + "' -> match=" + match);
                            if (match) {
                                medicinesToTake.add("• " + pm.getMedicineName() + " (" + pm.getDosage() + ")");
                            }
                        }
                    }
                }

                System.out.println("[MedReminder]   Medicines to take: " + medicinesToTake.size());

                if (!medicinesToTake.isEmpty()) {
                    String period = isMorning ? "Morning" : (isAfternoon ? "Afternoon" : "Night");
                    String title = period + " Medicines";
                    String details = "Please take the following medicines prescribed by your doctor:\n\n" + String.join("\n", medicinesToTake);
                    
                    System.out.println("[MedReminder]   SENDING to " + patient.getUser().getEmail());
                    emailService.sendReminderEmail(
                            patient.getUser().getEmail(),
                            patient.getUser().getFullName(),
                            title,
                            details
                    );
                    System.out.println("[MedReminder]   SENT OK!");
                }
            }
        } catch (Exception e) {
            System.err.println("[MedReminder] ERROR: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private List<Prescription> getActivePrescriptions(Patient patient, LocalDate nowDate) {
        List<Prescription> allPrescriptions = prescriptionRepository.findByPatientIdOrderByCreatedAtDesc(patient.getId());
        List<Prescription> active = new ArrayList<>();
        for (Prescription p : allPrescriptions) {
            if (p.getValidUntil() != null && !p.getValidUntil().isBefore(nowDate)) {
                active.add(p);
            } else if (p.getValidUntil() == null) {
                // If validUntil is null, we can check duration of medicines or just consider it active
                // For safety, let's include it or check if any medicine duration is still valid
                active.add(p);
            }
        }
        return active;
    }

    private boolean shouldTakeMedicineNow(String timing, boolean isMorning, boolean isAfternoon, boolean isNight) {
        if (timing == null || timing.trim().isEmpty()) return false;
        timing = timing.trim();

        // Primary: parse standardized "X-X-X" format (e.g. "1-0-1")
        String[] parts = timing.split("-");
        if (parts.length == 3) {
            try {
                int morning   = Integer.parseInt(parts[0].trim());
                int afternoon = Integer.parseInt(parts[1].trim());
                int night     = Integer.parseInt(parts[2].trim());
                if (isMorning   && morning   == 1) return true;
                if (isAfternoon && afternoon == 1) return true;
                if (isNight     && night     == 1) return true;
                return false;
            } catch (NumberFormatException e) {
                // Fall through to text-based matching
            }
        }

        // Fallback: text-based matching for legacy data
        String lower = timing.toLowerCase();
        if (isMorning && (lower.contains("morning") || lower.contains("daily") || lower.contains("everyday") || lower.equals("od"))) return true;
        if (isAfternoon && (lower.contains("afternoon") || lower.contains("daily") || lower.contains("everyday"))) return true;
        if (isNight && (lower.contains("night") || lower.contains("daily") || lower.contains("everyday"))) return true;

        return false;
    }
}
