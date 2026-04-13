package com.smarthealth.config;

import com.smarthealth.model.Department;
import com.smarthealth.model.Role;
import com.smarthealth.model.User;
import com.smarthealth.repository.jpa.DepartmentRepository;
import com.smarthealth.repository.jpa.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import com.smarthealth.model.SiteContent;
import com.smarthealth.model.mongo.SiteFeature;
import com.smarthealth.repository.jpa.SiteContentRepository;
import com.smarthealth.repository.mongo.SiteFeatureRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import org.springframework.stereotype.Component;

@Component
public class DataSeeder implements ApplicationListener<ContextRefreshedEvent> {

    @Autowired private UserRepository userRepository;
    @Autowired private DepartmentRepository departmentRepository;
    @Autowired private SiteContentRepository siteContentRepository;
    @Autowired private SiteFeatureRepository siteFeatureRepository;
    @Autowired private javax.sql.DataSource dataSource;

    private boolean seeded = false;

    @Override
    public void onApplicationEvent(ContextRefreshedEvent event) {
        if (seeded) return;
        seeded = true;
        
        try (java.sql.Connection conn = dataSource.getConnection(); 
             java.sql.Statement stmt = conn.createStatement()) {
            stmt.execute("ALTER TABLE users MODIFY COLUMN role VARCHAR(50)");
            System.out.println("INFO: Users table role column altered to VARCHAR(50) successfully.");
        } catch (Exception e) {
            System.out.println("INFO: Could not alter users table (might not exist yet or already altered): " + e.getMessage());
        }

        // Fix NULL values in assigned_by_reception column for existing rows
        try (java.sql.Connection conn = dataSource.getConnection();
             java.sql.Statement stmt = conn.createStatement()) {
            stmt.execute("UPDATE appointments SET assigned_by_reception = 0 WHERE assigned_by_reception IS NULL");
            System.out.println("INFO: Fixed NULL assigned_by_reception values in appointments table.");
        } catch (Exception e) {
            System.out.println("INFO: Could not fix assigned_by_reception (table may not exist yet): " + e.getMessage());
        }

        // Make doctor_id nullable to support reception-assigned appointments
        try (java.sql.Connection conn = dataSource.getConnection();
             java.sql.Statement stmt = conn.createStatement()) {
            stmt.execute("ALTER TABLE appointments MODIFY COLUMN doctor_id BIGINT NULL");
            System.out.println("INFO: appointments.doctor_id made nullable successfully.");
        } catch (Exception e) {
            System.out.println("INFO: Could not alter appointments.doctor_id (may already be nullable): " + e.getMessage());
        }

        // Make scheduledAt nullable to support reception-assigned appointments
        try (java.sql.Connection conn = dataSource.getConnection();
             java.sql.Statement stmt = conn.createStatement()) {
            stmt.execute("ALTER TABLE appointments MODIFY COLUMN scheduledAt DATETIME NULL");
            System.out.println("INFO: appointments.scheduledAt made nullable successfully.");
        } catch (Exception e) {
            System.out.println("INFO: Could not alter appointments.scheduledAt (may already be nullable): " + e.getMessage());
        }

        // Add token_number, estimated_time, preferred_date columns if missing
        try (java.sql.Connection conn = dataSource.getConnection();
             java.sql.Statement stmt = conn.createStatement()) {
            stmt.execute("ALTER TABLE appointments ADD COLUMN IF NOT EXISTS token_number INT NULL");
            stmt.execute("ALTER TABLE appointments ADD COLUMN IF NOT EXISTS estimated_time DATETIME NULL");
            stmt.execute("ALTER TABLE appointments ADD COLUMN IF NOT EXISTS preferred_date DATE NULL");
            System.out.println("INFO: appointments token/estimated/preferred_date columns ensured.");
        } catch (Exception e) {
            System.out.println("INFO: Could not add token columns (may already exist): " + e.getMessage());
        }

        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

        // Seed admin user
        if (!userRepository.existsByEmail("admin@health.com")) {
            User admin = new User();
            admin.setFullName("System Admin");
            admin.setEmail("admin@health.com");
            admin.setPassword(encoder.encode("admin123"));
            admin.setRole(Role.ADMIN);
            admin.setPhone("9999999999");
            admin.setActive(true);
            userRepository.save(admin);
        }

        // Seed receptionist user
        if (!userRepository.existsByEmail("reception@health.com")) {
            User reception = new User();
            reception.setFullName("Front Desk");
            reception.setEmail("reception@health.com");
            reception.setPassword(encoder.encode("reception123"));
            reception.setRole(Role.RECEPTIONIST);
            reception.setPhone("8888888888");
            reception.setActive(true);
            userRepository.save(reception);
        }

        // Seed reception user
        if (!userRepository.existsByEmail("reception@health.com")) {
            User reception = new User();
            reception.setFullName("Front Desk");
            reception.setEmail("reception@health.com");
            reception.setPassword(encoder.encode("reception123"));
            reception.setRole(Role.RECEPTIONIST);
            reception.setPhone("8888888888");
            reception.setActive(true);
            userRepository.save(reception);
        }

        // Seed departments
        if (departmentRepository.count() == 0) {
            String[][] depts = {
                {"Cardiology", "CARD", "30", "Dr. Patel", "Room 101", "+91-9000000001"},
                {"Neurology", "NEUR", "25", "Dr. Shah", "Room 202", "+91-9000000002"},
                {"Orthopedics", "ORTH", "20", "Dr. Mehta", "Room 303", "+91-9000000003"},
                {"Pediatrics", "PEDI", "35", "Dr. Singh", "Room 404", "+91-9000000004"},
                {"Emergency", "EMRG", "50", "Dr. Kumar", "Room 001", "+91-9000000005"}
            };
            for (String[] d : depts) {
                Department dept = new Department();
                dept.setName(d[0]);
                dept.setCode(d[1]);
                dept.setTargetCapacity(Integer.parseInt(d[2]));
                dept.setCurrOccupancy(0);
                dept.setStatus("ACTIVE");
                dept.setHeadName(d[3]);
                dept.setPhysicalLocation(d[4]);
                dept.setEmergencyPhone(d[5]);
                departmentRepository.save(dept);
            }
        }

        // Seed Site Content
        try {
            if (siteContentRepository.count() == 0) {
                SiteContent site = new SiteContent();
                site.setProjectTitle("Smart Health Monitor");
                site.setTagline("Revolutionizing Healthcare with Real-time Monitoring & Data Insights.");
                site.setAboutDescription("Smart Health Monitor is a comprehensive healthcare management system designed to bridge the gap between patients, doctors, and administrators. Utilizing modern technology, we provide real-time vital tracking, automated condition alerts, and seamless appointment management to ensure the best possible care for every patient.");
                site.setContactEmail("support@smarthealth.com");
                site.setContactPhone("+91-1800-123-456");
                site.setAddress("Health Tech Park, Sector 45, Mumbai, India");
                siteContentRepository.save(site);
                System.out.println("INFO: Site Content seeded successfully.");
            }
        } catch (Exception e) {
            System.err.println("ERROR: Failed to seed Site Content (MySQL). Ensure MySQL is running. " + e.getMessage());
        }

        // Seed Site Features
        try {
            if (siteFeatureRepository.count() == 0) {
                siteFeatureRepository.save(new SiteFeature("Patient Monitoring", "Real-time tracking of vitals like heart rate, blood pressure, and more with instant updates.", "bi-activity"));
                siteFeatureRepository.save(new SiteFeature("Doctor Management", "Efficiently manage doctor assignments, schedules, and clinical notes in one centralized place.", "bi-person-badge"));
                siteFeatureRepository.save(new SiteFeature("Appointment Booking", "Seamless scheduling system for patients with automated reminders and doctor availability sync.", "bi-calendar-check"));
                siteFeatureRepository.save(new SiteFeature("Report Management", "Securely upload and share medical reports and prescriptions between doctors and patients.", "bi-file-earmark-medical"));
                siteFeatureRepository.save(new SiteFeature("Condition Alerts", "Automated system that notifies doctors immediately when a patient's vitals exceed safe thresholds.", "bi-bell"));
                siteFeatureRepository.save(new SiteFeature("Admin Analytics", "Advanced dashboad for administrators to analyze hospital efficiency and patient trends.", "bi-graph-up"));
                System.out.println("INFO: Site Features seeded successfully.");
            }
        } catch (Exception e) {
            System.err.println("ERROR: Failed to seed Site Features (MongoDB). Ensure MongoDB is running. " + e.getMessage());
        }

    }
}
