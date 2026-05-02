package com.smarthealth.service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import com.smarthealth.config.EnvConfig;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    public void sendOtpEmail(String to, String otp) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(to);
            helper.setSubject("Your One-Time Password (OTP) for Smart Health Password Reset");

            String content = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd; border-radius: 10px; max-width: 500px;'>"
                    +
                    "<h2 style='color: #2563eb;'>Smart Health Password Reset</h2>" +
                    "<p>You requested a password reset. Please use the following One-Time Password (OTP) to verify your identity:</p>"
                    +
                    "<div style='font-size: 2rem; font-weight: bold; padding: 15px; background: #f3f4f6; text-align: center; border-radius: 8px; margin: 20px 0;'>"
                    + otp + "</div>" +
                    "<p>This OTP is valid for 10 minutes. If you did not request this, please ignore this email.</p>" +
                    "<hr style='border: none; border-top: 1px solid #ddd; margin-top: 20px;'>" +
                    "<p style='font-size: 0.85rem; color: #6b7280;'>© 2026 Smart Health Monitor Project. All rights reserved.</p>"
                    +
                    "</div>";

            helper.setText(content, true);
            mailSender.send(message);
        } catch (MessagingException | org.springframework.mail.MailException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to send OTP email due to system error.");
        }
    }

    public void sendEmergencyAlert(String to, String patientName, String vitals, String location) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(to);
            helper.setSubject("🚨 EMERGENCY ALERT: High Risk Detected for " + patientName);

            String content = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 2px solid #ef4444; border-radius: 12px; max-width: 600px;'>"
                    +
                    "<h2 style='color: #ef4444; margin-top: 0;'>🚨 Emergency Medical Alert</h2>" +
                    "<p>This is an automated emergency notification because <strong>" + patientName
                    + "</strong> has been detected with critical health vitals.</p>" +
                    "<div style='background: #fef2f2; padding: 15px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #ef4444;'>"
                    +
                    "<p><strong>Current Vitals:</strong><br>" + vitals + "</p>" +
                    "<p><strong>Last Known Location:</strong><br><a href='" + location
                    + "' style='color: #2563eb;'>View on Google Maps</a></p>" +
                    "</div>" +
                    "<p>Please take immediate action or contact emergency services.</p>" +
                    "<hr style='border: none; border-top: 1px solid #ddd; margin-top: 20px;'>" +
                    "<p style='font-size: 0.85rem; color: #6b7280;'>© 2026 Smart Health Monitor Project. Critical Health Alert System.</p>"
                    +
                    "</div>";

            helper.setText(content, true);
            mailSender.send(message);
        } catch (MessagingException | MailException e) {
            e.printStackTrace();
        }
    }

    public void sendAppointmentBookingNotification(String to, String patientName, String doctorName,
            String scheduledAt) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(to);
            helper.setSubject("Appointment Booked - Smart Health Monitor");

            String content = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd; border-radius: 10px; max-width: 500px;'>"
                    +
                    "<h2 style='color: #2563eb;'>Appointment Booked Successfully</h2>" +
                    "<p>Dear " + patientName + ",</p>" +
                    "<p>You have successfully booked an appointment with <strong>Dr. " + doctorName + "</strong>.</p>" +
                    "<div style='padding: 15px; background: #f3f4f6; border-radius: 8px; margin: 20px 0;'>" +
                    "<p style='margin: 0;'><strong>Date & Time:</strong> " + scheduledAt + "</p>" +
                    "<p style='margin: 0;'><strong>Status:</strong> PENDING</p>" +
                    "</div>" +
                    "<p>The doctor will review and confirm your request shortly.</p>" +
                    "<hr style='border: none; border-top: 1px solid #ddd; margin-top: 20px;'>" +
                    "<p style='font-size: 0.85rem; color: #6b7280;'>© 2026 Smart Health Monitor Project.</p>" +
                    "</div>";

            helper.setText(content, true);
            mailSender.send(message);
        } catch (MessagingException | MailException e) {
            e.printStackTrace();
        }
    }

    public void sendAppointmentConfirmation(String to, String patientName, String doctorName, String scheduledAt) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(to);
            helper.setSubject("Appointment Confirmed! - Smart Health Monitor");

            String content = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #10b981; border-radius: 12px; max-width: 500px;'>"
                    +
                    "<h2 style='color: #10b981;'>Appointment Confirmed</h2>" +
                    "<p>Great news, " + patientName + "!</p>" +
                    "<p>Your appointment has been <strong>confirmed</strong> by <strong>Dr. " + doctorName
                    + "</strong>.</p>" +
                    "<div style='padding: 15px; background: #f0fdf4; border-radius: 8px; margin: 20px 0; border-left: 4px solid #10b981;'>"
                    +
                    "<p style='margin: 0;'><strong>Scheduled For:</strong> " + scheduledAt + "</p>" +
                    "</div>" +
                    "<p>Please make sure to be available at the scheduled time.</p>" +
                    "<hr style='border: none; border-top: 1px solid #ddd; margin-top: 20px;'>" +
                    "<p style='font-size: 0.85rem; color: #6b7280;'>© 2026 Smart Health Monitor Project.</p>" +
                    "</div>";

            helper.setText(content, true);
            mailSender.send(message);
        } catch (MessagingException | MailException e) {
            e.printStackTrace();
        }
    }

    public void sendPrescriptionPdf(String to, String patientName, String doctorName, byte[] pdfData) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(to);
            helper.setSubject("Your Prescription - Smart Health Monitor");

            String content = "Dear " + patientName + ",\n\n" +
                    "Attached is your prescription from Dr. " + doctorName + ".\n\n" +
                    "Regards,\nSmart Health Monitor";

            helper.setText(content);
            helper.addAttachment("Prescription.pdf", new org.springframework.core.io.ByteArrayResource(pdfData));
            mailSender.send(message);
        } catch (MessagingException | MailException e) {
            e.printStackTrace();
        }
    }

    public void sendAppointmentAssignedByReception(String to, String patientName, String doctorName, String specialty,
            String scheduledAt) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(to);
            helper.setSubject("Appointment Assigned — Smart Health Monitor");
            String content = "<div style='font-family:Arial,sans-serif;padding:20px;border:1px solid #3b82f6;border-radius:12px;max-width:520px;'>"
                    +
                    "<h2 style='color:#1d4ed8;'>Appointment Confirmed by Reception</h2>" +
                    "<p>Dear <strong>" + patientName + "</strong>,</p>" +
                    "<p>Our reception team has reviewed your appointment request and assigned a doctor for you.</p>" +
                    "<div style='background:#eff6ff;padding:15px;border-radius:8px;margin:20px 0;border-left:4px solid #3b82f6;'>"
                    +
                    "<p style='margin:0 0 8px 0;'><strong>Doctor:</strong> Dr. " + doctorName + "</p>" +
                    "<p style='margin:0 0 8px 0;'><strong>Specialty:</strong> " + specialty + "</p>" +
                    "<p style='margin:0;'><strong>Scheduled For:</strong> " + scheduledAt + "</p>" +
                    "</div>" +
                    "<p>Please be available at the scheduled time. The doctor will confirm your appointment shortly.</p>"
                    +
                    "<hr style='border:none;border-top:1px solid #ddd;margin-top:20px;'>" +
                    "<p style='font-size:0.85rem;color:#6b7280;'>© 2026 Smart Health Monitor Project.</p>" +
                    "</div>";
            helper.setText(content, true);
            mailSender.send(message);
        } catch (MessagingException | MailException e) {
            e.printStackTrace();
        }
    }

    public void sendReportUpdate(String to, String patientName, String title, String status) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(to);
            helper.setSubject("Medical Report Update - Smart Health Monitor");

            String content = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #3b82f6; border-radius: 12px; max-width: 500px;'>"
                    +
                    "<h2 style='color: #3b82f6;'>Report Status Updated</h2>" +
                    "<p>Dear " + patientName + ",</p>" +
                    "<p>Your medical report <strong>" + title + "</strong> has been updated.</p>" +
                    "<p>New Status: <strong>" + status + "</strong></p>" +
                    "<p>Please log in to your portal to view the details.</p>" +
                    "<hr style='border: none; border-top: 1px solid #ddd; margin-top: 20px;'>" +
                    "<p style='font-size: 0.85rem; color: #6b7280;'>© 2026 Smart Health Monitor Project.</p>" +
                    "</div>";

            helper.setText(content, true);
            mailSender.send(message);
        } catch (MessagingException | MailException e) {
            e.printStackTrace();
        }
    }

    public void sendLabRequestProcessingEmail(String to, String patientName, String testName) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(to);
            helper.setSubject("Lab Test Processing: " + testName + " — Smart Health");
            String content = "<div style='font-family:Arial,sans-serif;padding:25px;border:1px solid #3b82f6;border-radius:12px;max-width:550px;'>" +
                    "<h2 style='color:#1d4ed8;'>Test In Progress</h2>" +
                    "<p>Dear " + patientName + ",</p>" +
                    "<p>Your laboratory test <strong>" + testName + "</strong> is now being processed by our clinical team.</p>" +
                    "<div style='background:#eff6ff;padding:15px;border-radius:8px;margin:20px 0;border-left:4px solid #3b82f6;'>" +
                    "Status: <strong>IN PROGRESS</strong>" +
                    "</div>" +
                    "<p>You will receive another notification once the results are ready.</p>" +
                    "<hr style='border:none;border-top:1px solid #ddd;margin-top:20px;'>" +
                    "<p style='font-size:0.85rem;color:#6b7280;'>© 2026 Smart Health Hospital Laboratory.</p>" +
                    "</div>";
            helper.setText(content, true);
            mailSender.send(message);
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void sendLabReportCompletedEmail(String to, String patientName, String testName) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(to);
            helper.setSubject("Lab Report Ready: " + testName + " — Smart Health");
            String content = "<div style='font-family:Arial,sans-serif;padding:25px;border:1px solid #10b981;border-radius:12px;max-width:550px;'>" +
                    "<h2 style='color:#059669;'>Report Completed</h2>" +
                    "<p>Dear " + patientName + ",</p>" +
                    "<p>Great news! Your laboratory results for <strong>" + testName + "</strong> are now available.</p>" +
                    "<div style='background:#f0fdf4;padding:15px;border-radius:8px;margin:20px 0;border-left:4px solid #10b981;'>" +
                    "Status: <strong>COMPLETED</strong>" +
                    "</div>" +
                    "<p>You can now view and download your report from the Patient Portal. An invoice has also been generated for this service.</p>" +
                    "<hr style='border:none;border-top:1px solid #ddd;margin-top:20px;'>" +
                    "<p style='font-size:0.85rem;color:#6b7280;'>© 2026 Smart Health Hospital Laboratory.</p>" +
                    "</div>";
            helper.setText(content, true);
            mailSender.send(message);
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void sendContactConfirmation(String to, String name) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(to);
            helper.setSubject("We've received your message — Smart Health Monitor");

            String content = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #e2e8f0; border-radius: 12px; max-width: 500px; background-color: #f8fafc;'>"
                    +
                    "<h2 style='color: #2563eb;'>Thank you for reaching out, " + name + "!</h2>" +
                    "<p>We have received your message and our team will review it shortly.</p>" +
                    "<div style='background: white; padding: 15px; border-radius: 8px; margin: 20px 0; border: 1px solid #e2e8f0;'>"
                    +
                    "<p style='margin: 0; color: #64748b; font-size: 0.9rem;'>You can expect a reply from us within 24-48 business hours.</p>"
                    +
                    "</div>" +
                    "<p>Regards,<br><strong>The Smart Health Support Team</strong></p>" +
                    "<hr style='border: none; border-top: 1px solid #e2e8f0; margin-top: 20px;'>" +
                    "<p style='font-size: 0.8rem; color: #94a3b8;'>© 2026 Smart Health Monitor. All rights reserved.</p>"
                    +
                    "</div>";

            helper.setText(content, true);
            mailSender.send(message);
        } catch (MessagingException | MailException e) {
            e.printStackTrace();
        }
    }

    public void sendAdminReply(String to, String name, String originalMessage, String reply) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(to);
            helper.setSubject("Reply to your inquiry — Smart Health Monitor");

            String content = "<div style='font-family: Arial, sans-serif; padding: 30px; border: 1px solid #3b82f6; border-radius: 16px; max-width: 600px; color: #1e293b;'>"
                    +
                    "<div style='display: flex; align-items: center; margin-bottom: 20px;'>" +
                    "<h2 style='color: #1d4ed8; margin: 0;'>New Update on Your Inquiry</h2>" +
                    "</div>" +
                    "<p>Hello <strong>" + name + "</strong>,</p>" +
                    "<p>Our administration team has reviewed your recent message and provided a response:</p>" +

                    "<div style='background: #f1f5f9; padding: 20px; border-radius: 12px; margin: 20px 0; border-left: 5px solid #3b82f6;'>"
                    +
                    "<p style='margin-top: 0; color: #64748b; font-size: 0.85rem; text-transform: uppercase; font-weight: bold;'>Administrator Response:</p>"
                    +
                    "<p style='font-style: italic; font-size: 1.1rem; line-height: 1.6;'>" + reply + "</p>" +
                    "</div>" +

                    "<div style='margin-top: 30px; padding-top: 20px; border-top: 1px solid #e2e8f0;'>" +
                    "<p style='color: #64748b; font-size: 0.85rem; margin-bottom: 10px;'>Reference to your original message:</p>"
                    +
                    "<p style='color: #94a3b8; font-size: 0.9rem; line-height: 1.5;'>" + originalMessage + "</p>" +
                    "</div>" +

                    "<p style='margin-top: 30px;'>Thank you for using our platform.</p>" +
                    "<p>Best Regards,<br><strong>Smart Health Administration</strong></p>" +
                    "</div>";

            helper.setText(content, true);
            mailSender.send(message);
        } catch (MessagingException | MailException e) {
            e.printStackTrace();
        }
    }

    /**
     * Sends a basic text email.
     */
    public void sendEmail(String to, String subject, String body) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(body.replace("\n", "<br>"), true);
            mailSender.send(message);
        } catch (MessagingException | MailException e) {
            e.printStackTrace();
        }
    }

    /**
     * Sends a styled broadcast/bulk email from admin to a list of recipients.
     */
    public int sendBroadcastEmail(java.util.List<String> toEmails, String subject, String body) {
        int successCount = 0;
        for (String to : toEmails) {
            try {
                MimeMessage message = mailSender.createMimeMessage();
                MimeMessageHelper helper = new MimeMessageHelper(message, true);
                helper.setTo(to);
                helper.setSubject(subject + " — Smart Health Monitor");

                String content = "<div style='font-family: Arial, sans-serif; padding: 30px; max-width: 600px; border: 1px solid #e2e8f0; border-radius: 16px; color: #1e293b;'>"
                        +
                        "<div style='background: linear-gradient(135deg, #004d99, #0077cc); padding: 20px 25px; border-radius: 12px 12px 0 0; margin: -30px -30px 25px -30px;'>"
                        +
                        "<h2 style='color: #ffffff; margin: 0; font-size: 1.4rem;'>" + subject + "</h2>" +
                        "<p style='color: rgba(255,255,255,0.75); margin: 5px 0 0 0; font-size: 0.85rem;'>Official Notification from Smart Health Hospital</p>"
                        +
                        "</div>" +

                        "<div style='background: #f8fafc; padding: 20px; border-radius: 12px; margin-bottom: 25px; border-left: 5px solid #004d99; line-height: 1.7; font-size: 1rem;'>"
                        +
                        body.replace("\n", "<br>") +
                        "</div>" +

                        "<p style='color: #64748b; font-size: 0.9rem;'>This is an automated message from the Smart Health Hospital administration. If you have questions, please contact support.</p>"
                        +
                        "<hr style='border: none; border-top: 1px solid #e2e8f0; margin: 20px 0;'>" +
                        "<p style='font-size: 0.8rem; color: #94a3b8;'>© 2026 Smart Health Monitor. All rights reserved.</p>"
                        +
                        "</div>";

                helper.setText(content, true);
                mailSender.send(message);
                successCount++;
            } catch (MessagingException | org.springframework.mail.MailException e) {
                e.printStackTrace();
                // continue to next recipient
            }
        }
        return successCount;
    }

    public void sendWelcomeCredentials(String to, String name, String role, String password) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(to);
            helper.setSubject("Welcome to Smart Health - Your Account Credentials");

            String content = "<div style='font-family: Arial, sans-serif; padding: 25px; border: 1px solid #3b82f6; border-radius: 12px; max-width: 550px;'>"
                    +
                    "<h2 style='color: #2563eb;'>Welcome to the Team, " + name + "!</h2>" +
                    "<p>An official account has been created for you as a <strong>" + role
                    + "</strong> on the Smart Health Monitor platform.</p>" +
                    "<div style='background: #f8fafc; padding: 20px; border-radius: 10px; margin: 20px 0; border: 1px solid #e2e8f0;'>"
                    +
                    "<p style='margin: 0; color: #64748b; font-size: 0.9rem;'>Use the credentials below to log in:</p>"
                    +
                    "<p style='margin: 10px 0 5px 0;'><strong>Username/Email:</strong> " + to + "</p>" +
                    "<p style='margin: 0;'><strong>Initial Password:</strong> <code style='background: #f1f5f9; padding: 2px 5px; border-radius: 4px;'>"
                    + password + "</code></p>" +
                    "</div>" +
                    "<p style='color: #ef4444; font-size: 0.9rem;'><strong>Security Tip:</strong> Please change your password immediately after your first login.</p>"
                    +
                    "<hr style='border: none; border-top: 1px solid #e2e8f0; margin-top: 20px;'>" +
                    "<p style='font-size: 0.8rem; color: #94a3b8;'>© 2026 Smart Health Monitor. Confidentially handled medical operations.</p>"
                    +
                    "</div>";

            helper.setText(content, true);
            mailSender.send(message);
        } catch (MessagingException | MailException e) {
            e.printStackTrace();
        }
    }

    public void sendReminderEmail(String to, String patientName, String title, String details) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(to);
            helper.setSubject("Reminder: " + title + " - Smart Health Monitor");

            String content = "<div style='font-family: Arial, sans-serif; padding: 25px; border: 1px solid #10b981; border-radius: 12px; max-width: 550px;'>"
                    +
                    "<h2 style='color: #10b981; margin-top: 0;'>Health Reminder</h2>" +
                    "<p>Hello <strong>" + patientName + "</strong>,</p>" +
                    "<p>This is a friendly reminder for: <strong>" + title + "</strong></p>" +
                    "<div style='background: #f0fdf4; padding: 20px; border-radius: 10px; margin: 20px 0; border-left: 4px solid #10b981;'>"
                    +
                    "<p style='margin: 0; line-height: 1.6;'>" + details.replace("\n", "<br>") + "</p>" +
                    "</div>" +
                    "<p>Stay healthy!</p>" +
                    "<hr style='border: none; border-top: 1px solid #e2e8f0; margin-top: 20px;'>" +
                    "<p style='font-size: 0.8rem; color: #94a3b8;'>© 2026 Smart Health Monitor. Your Health Partner.</p>"
                    +
                    "</div>";

            helper.setText(content, true);
            mailSender.send(message);
        } catch (MessagingException | MailException e) {
            e.printStackTrace();
        }
    }

    public void sendDoctorApprovalEmail(String to, String doctorName, String specialty) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(to);
            helper.setSubject("Account Approved - Smart Health Doctor Portal");

            String content = "<div style='font-family: Arial, sans-serif; padding: 25px; border: 1px solid #3b82f6; border-radius: 12px; max-width: 550px;'>"
                    +
                    "<h2 style='color: #2563eb;'>Congratulations, Dr. " + doctorName + "!</h2>" +
                    "<p>Your registration request for the <strong>" + specialty
                    + "</strong> specialty has been <strong>approved</strong> by our administration team.</p>" +
                    "<div style='background: #f0f9ff; padding: 20px; border-radius: 10px; margin: 20px 0; border-left: 4px solid #3b82f6;'>"
                    +
                    "<p style='margin: 0;'>Your account is now fully active. You can now log in to the doctor portal to manage your appointments, view patient records, and issue prescriptions.</p>"
                    +
                    "</div>" +
                    "<div style='text-align: center; margin: 30px 0;'>" +
                    "<a href='" + EnvConfig.get("APP_URL", "http://localhost:8080/smart_health_monitor") + "/auth/doctor/login' style='background: #2563eb; color: white; padding: 12px 25px; text-decoration: none; border-radius: 6px; font-weight: bold;'>Login to Portal</a>"
                    +
                    "</div>" +
                    "<p>If you have any questions, please contact the hospital IT support.</p>" +
                    "<hr style='border: none; border-top: 1px solid #e2e8f0; margin-top: 20px;'>" +
                    "<p style='font-size: 0.8rem; color: #94a3b8;'>© 2026 Smart Health Monitor. Confidentially handled medical operations.</p>"
                    +
                    "</div>";

            helper.setText(content, true);
            mailSender.send(message);
        } catch (MessagingException | MailException e) {
            e.printStackTrace();
        }
    }

    private byte[] generateInvoicePdf(String patientName, com.smarthealth.model.Payment payment) {
        try (java.io.ByteArrayOutputStream out = new java.io.ByteArrayOutputStream()) {
            com.itextpdf.text.Document document = new com.itextpdf.text.Document();
            com.itextpdf.text.pdf.PdfWriter.getInstance(document, out);
            document.open();

            com.itextpdf.text.Font titleFont = com.itextpdf.text.FontFactory.getFont(com.itextpdf.text.FontFactory.HELVETICA_BOLD, 20, com.itextpdf.text.BaseColor.BLACK);
            com.itextpdf.text.Font headerFont = com.itextpdf.text.FontFactory.getFont(com.itextpdf.text.FontFactory.HELVETICA_BOLD, 12, com.itextpdf.text.BaseColor.DARK_GRAY);
            com.itextpdf.text.Font normalFont = com.itextpdf.text.FontFactory.getFont(com.itextpdf.text.FontFactory.HELVETICA, 11, com.itextpdf.text.BaseColor.BLACK);

            boolean isRefund = payment.getAmount() < 0;
            String headerText = isRefund ? "Refund Receipt" : "Payment Invoice";

            com.itextpdf.text.Paragraph title = new com.itextpdf.text.Paragraph("Smart Health Hospital\n" + headerText, titleFont);
            title.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
            title.setSpacingAfter(20f);
            document.add(title);

            String invoiceNumber = "INV-" + (payment.getId() != null ? String.format("%06d", payment.getId()) : "PENDING");
            String dateStr = payment.getCreatedAt() != null ? payment.getCreatedAt().toString().replace("T", " ").substring(0, 16) : java.time.LocalDateTime.now().toString().replace("T", " ").substring(0, 16);
            
            document.add(new com.itextpdf.text.Paragraph("Invoice No: " + invoiceNumber, normalFont));
            document.add(new com.itextpdf.text.Paragraph("Date: " + dateStr, normalFont));
            document.add(new com.itextpdf.text.Paragraph("Patient Name: " + patientName, normalFont));
            document.add(new com.itextpdf.text.Paragraph("\n"));

            com.itextpdf.text.pdf.PdfPTable table = new com.itextpdf.text.pdf.PdfPTable(2);
            table.setWidthPercentage(100);
            table.setSpacingBefore(10f);
            table.setSpacingAfter(10f);

            com.itextpdf.text.pdf.PdfPCell cell1 = new com.itextpdf.text.pdf.PdfPCell(new com.itextpdf.text.Phrase("Description", headerFont));
            cell1.setPadding(8f);
            cell1.setBackgroundColor(new com.itextpdf.text.BaseColor(243, 244, 246));
            table.addCell(cell1);
            
            com.itextpdf.text.pdf.PdfPCell cell2 = new com.itextpdf.text.pdf.PdfPCell(new com.itextpdf.text.Phrase("Amount (INR)", headerFont));
            cell2.setPadding(8f);
            cell2.setBackgroundColor(new com.itextpdf.text.BaseColor(243, 244, 246));
            cell2.setHorizontalAlignment(com.itextpdf.text.Element.ALIGN_RIGHT);
            table.addCell(cell2);

            String description = payment.getDescription() != null && !payment.getDescription().isEmpty() ? payment.getDescription() : payment.getType() + " Payment";
            com.itextpdf.text.pdf.PdfPCell descCell = new com.itextpdf.text.pdf.PdfPCell(new com.itextpdf.text.Phrase(description + "\n(Method: " + payment.getMethod() + ")", normalFont));
            descCell.setPadding(8f);
            table.addCell(descCell);

            String amountStr = String.format("%.2f", Math.abs(payment.getAmount()));
            com.itextpdf.text.pdf.PdfPCell amountCell = new com.itextpdf.text.pdf.PdfPCell(new com.itextpdf.text.Phrase(amountStr, normalFont));
            amountCell.setPadding(8f);
            amountCell.setHorizontalAlignment(com.itextpdf.text.Element.ALIGN_RIGHT);
            table.addCell(amountCell);

            document.add(table);

            com.itextpdf.text.Paragraph total = new com.itextpdf.text.Paragraph("Total: Rs. " + amountStr, titleFont);
            total.setAlignment(com.itextpdf.text.Element.ALIGN_RIGHT);
            document.add(total);

            document.add(new com.itextpdf.text.Paragraph("\n\nThank you for choosing Smart Health Hospital!", normalFont));

            document.close();
            return out.toByteArray();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void sendPaymentInvoiceEmail(String to, String patientName, com.smarthealth.model.Payment payment) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            boolean isRefund = payment.getAmount() < 0;
            String headerText = isRefund ? "Refund Receipt" : "Payment Invoice";
            helper.setSubject(headerText + " - Smart Health Monitor");
            helper.setTo(to);

            String invoiceNumber = "INV-" + (payment.getId() != null ? String.format("%06d", payment.getId()) : "PENDING");
            String dateStr = payment.getCreatedAt() != null ? payment.getCreatedAt().toString().replace("T", " ").substring(0, 16) : java.time.LocalDateTime.now().toString().replace("T", " ").substring(0, 16);
            String amountStr = String.format("%.2f", Math.abs(payment.getAmount()));
            String headerColor = isRefund ? "#f59e0b" : "#10b981";
            String description = payment.getDescription() != null && !payment.getDescription().isEmpty() ? payment.getDescription() : payment.getType() + " Payment";

            String content = "<div style='font-family: Arial, sans-serif; padding: 25px; border: 1px solid #e5e7eb; border-radius: 12px; max-width: 600px; margin: 0 auto;'>"
                    + "<div style='text-align: center; border-bottom: 2px solid " + headerColor + "; padding-bottom: 15px; margin-bottom: 20px;'>"
                    + "<h1 style='color: " + headerColor + "; margin: 0;'>" + headerText + "</h1>"
                    + "<p style='color: #6b7280; margin: 5px 0 0 0;'>Smart Health Hospital</p>"
                    + "</div>"
                    + "<div style='display: flex; justify-content: space-between; margin-bottom: 20px; font-size: 0.9rem; color: #374151;'>"
                    + "<div><strong>Invoice No:</strong> " + invoiceNumber + "<br><br><strong>Date:</strong> " + dateStr + "</div>"
                    + "<div style='text-align: right;'><strong>Patient:</strong> " + patientName + "<br><br><strong>Email:</strong> " + to + "</div>"
                    + "</div>"
                    + "<table style='width: 100%; border-collapse: collapse; margin-bottom: 25px;'>"
                    + "<tr style='background-color: #f3f4f6; text-align: left;'><th style='padding: 10px; border-bottom: 1px solid #e5e7eb;'>Description</th><th style='padding: 10px; border-bottom: 1px solid #e5e7eb; text-align: right;'>Amount (INR)</th></tr>"
                    + "<tr><td style='padding: 12px 10px; border-bottom: 1px solid #e5e7eb;'>" + description + "<br><small style='color: #6b7280;'>Method: " + payment.getMethod() + "</small></td>"
                    + "<td style='padding: 12px 10px; border-bottom: 1px solid #e5e7eb; text-align: right; font-weight: bold;'>" + amountStr + "</td></tr>"
                    + "</table>"
                    + "<div style='text-align: right; font-size: 1.2rem; color: #111827; margin-bottom: 30px;'>"
                    + "<strong>Total: </strong><span style='color: " + headerColor + "; font-size: 1.4rem;'>₹" + amountStr + "</span>"
                    + "</div>"
                    + "<div style='background: #f9fafb; padding: 15px; border-radius: 8px; text-align: center; color: #4b5563; font-size: 0.85rem;'>"
                    + "<p style='margin: 0;'>Please find the attached PDF invoice for your records.</p>"
                    + "<p style='margin: 5px 0 0 0;'>For any billing queries, please contact our support.</p>"
                    + "</div>"
                    + "</div>";

            helper.setText(content, true);

            byte[] pdfBytes = generateInvoicePdf(patientName, payment);
            if (pdfBytes != null) {
                helper.addAttachment("Invoice_" + invoiceNumber + ".pdf", new org.springframework.core.io.ByteArrayResource(pdfBytes));
            }

            mailSender.send(message);
        } catch (MessagingException | MailException e) {
            e.printStackTrace();
        }
    }
}
