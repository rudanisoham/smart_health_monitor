package com.smarthealth.controller;

import com.smarthealth.model.User;
import com.smarthealth.service.EmailService;
import com.smarthealth.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.Random;

@Controller
@RequestMapping("/auth/forgot")
public class ForgotPasswordController {

    @Autowired private UserService userService;
    @Autowired private EmailService emailService;
    @Autowired private PasswordEncoder passwordEncoder;

    @GetMapping
    public String showForgotForm() {
        return "auth/forgot-password";
    }

    @PostMapping("/send-otp")
    public String sendOtp(@RequestParam String email, HttpSession session, RedirectAttributes ra) {
        User user = userService.findByEmail(email).orElse(null);
        if (user == null) {
            ra.addFlashAttribute("error", "No account found with this email address.");
            return "redirect:/auth/forgot";
        }

        // Generate 6-digit OTP
        String otp = String.format("%06d", new Random().nextInt(1000000));
        user.setResetPasswordOtp(otp);
        user.setOtpExpiry(LocalDateTime.now().plusMinutes(10));
        userService.update(user);

        // Send OTP via Email
        try {
            emailService.sendOtpEmail(email, otp);
            session.setAttribute("resetEmail", email);
            ra.addFlashAttribute("success", "A One-Time Password (OTP) has been sent to your email.");
            return "redirect:/auth/forgot/verify";
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error sending email. Please try again.");
            return "redirect:/auth/forgot";
        }
    }

    @GetMapping("/verify")
    public String showVerifyForm(HttpSession session) {
        if (session.getAttribute("resetEmail") == null) return "redirect:/auth/forgot";
        return "auth/verify-otp";
    }

    @PostMapping("/verify-otp")
    public String verifyOtp(@RequestParam String otp, HttpSession session, Model model, RedirectAttributes ra) {
        String email = (String) session.getAttribute("resetEmail");
        if (email == null) return "redirect:/auth/forgot";

        User user = userService.findByEmail(email).orElse(null);
        if (user == null || user.getResetPasswordOtp() == null || !user.getResetPasswordOtp().equals(otp)) {
            ra.addFlashAttribute("error", "Invalid or expired OTP. Please try again.");
            return "redirect:/auth/forgot/verify";
        }

        if (user.getOtpExpiry().isBefore(LocalDateTime.now())) {
            ra.addFlashAttribute("error", "OTP has expired. Please request a new one.");
            return "redirect:/auth/forgot";
        }

        session.setAttribute("otpVerified", true);
        return "redirect:/auth/forgot/reset";
    }

    @GetMapping("/reset")
    public String showResetForm(HttpSession session) {
        if (session.getAttribute("otpVerified") == null) return "redirect:/auth/forgot";
        return "auth/reset-password";
    }

    @PostMapping("/reset-password")
    public String resetPassword(@RequestParam String password, @RequestParam String confirmPassword, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("otpVerified") == null) return "redirect:/auth/forgot";
        String email = (String) session.getAttribute("resetEmail");

        if (!password.equals(confirmPassword)) {
            ra.addFlashAttribute("error", "Passwords do not match.");
            return "redirect:/auth/forgot/reset";
        }

        User user = userService.findByEmail(email).orElse(null);
        if (user != null) {
            user.setPassword(passwordEncoder.encode(password));
            user.setResetPasswordOtp(null);
            user.setOtpExpiry(null);
            userService.update(user);
            ra.addFlashAttribute("success", "Password reset successful. You can now login.");
        }

        session.removeAttribute("resetEmail");
        session.removeAttribute("otpVerified");
        return "redirect:/auth/login";
    }
}
