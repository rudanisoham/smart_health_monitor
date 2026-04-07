package com.smarthealth.service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

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
            
            String content = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd; border-radius: 10px; max-width: 500px;'>" +
                             "<h2 style='color: #2563eb;'>Smart Health Password Reset</h2>" +
                             "<p>You requested a password reset. Please use the following One-Time Password (OTP) to verify your identity:</p>" +
                             "<div style='font-size: 2rem; font-weight: bold; padding: 15px; background: #f3f4f6; text-align: center; border-radius: 8px; margin: 20px 0;'>" + otp + "</div>" +
                             "<p>This OTP is valid for 10 minutes. If you did not request this, please ignore this email.</p>" +
                             "<hr style='border: none; border-top: 1px solid #ddd; margin-top: 20px;'>" +
                             "<p style='font-size: 0.85rem; color: #6b7280;'>© 2026 Smart Health Monitor Project. All rights reserved.</p>" +
                             "</div>";
            
            helper.setText(content, true);
            mailSender.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to send OTP email.");
        }
    }

    public void sendEmergencyAlert(String to, String patientName, String vitals, String location) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(to);
            helper.setSubject("🚨 EMERGENCY ALERT: High Risk Detected for " + patientName);
            
            String content = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 2px solid #ef4444; border-radius: 12px; max-width: 600px;'>" +
                             "<h2 style='color: #ef4444; margin-top: 0;'>🚨 Emergency Medical Alert</h2>" +
                             "<p>This is an automated emergency notification because <strong>" + patientName + "</strong> has been detected with critical health vitals.</p>" +
                             "<div style='background: #fef2f2; padding: 15px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #ef4444;'>" +
                             "<p><strong>Current Vitals:</strong><br>" + vitals + "</p>" +
                             "<p><strong>Last Known Location:</strong><br><a href='" + location + "' style='color: #2563eb;'>View on Google Maps</a></p>" +
                             "</div>" +
                             "<p>Please take immediate action or contact emergency services.</p>" +
                             "<hr style='border: none; border-top: 1px solid #ddd; margin-top: 20px;'>" +
                             "<p style='font-size: 0.85rem; color: #6b7280;'>© 2026 Smart Health Monitor Project. Critical Health Alert System.</p>" +
                             "</div>";
            
            helper.setText(content, true);
            mailSender.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    public void sendAppointmentBookingNotification(String to, String patientName, String doctorName, String scheduledAt) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(to);
            helper.setSubject("Appointment Booked - Smart Health Monitor");
            
            String content = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd; border-radius: 10px; max-width: 500px;'>" +
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
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    public void sendAppointmentConfirmation(String to, String patientName, String doctorName, String scheduledAt) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(to);
            helper.setSubject("Appointment Confirmed! - Smart Health Monitor");
            
            String content = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #10b981; border-radius: 12px; max-width: 500px;'>" +
                             "<h2 style='color: #10b981;'>Appointment Confirmed</h2>" +
                             "<p>Great news, " + patientName + "!</p>" +
                             "<p>Your appointment has been <strong>confirmed</strong> by <strong>Dr. " + doctorName + "</strong>.</p>" +
                             "<div style='padding: 15px; background: #f0fdf4; border-radius: 8px; margin: 20px 0; border-left: 4px solid #10b981;'>" +
                             "<p style='margin: 0;'><strong>Scheduled For:</strong> " + scheduledAt + "</p>" +
                             "</div>" +
                             "<p>Please make sure to be available at the scheduled time.</p>" +
                             "<hr style='border: none; border-top: 1px solid #ddd; margin-top: 20px;'>" +
                             "<p style='font-size: 0.85rem; color: #6b7280;'>© 2026 Smart Health Monitor Project.</p>" +
                             "</div>";
            
            helper.setText(content, true);
            mailSender.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
