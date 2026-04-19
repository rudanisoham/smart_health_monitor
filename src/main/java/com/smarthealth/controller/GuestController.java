package com.smarthealth.controller;

import com.smarthealth.model.ContactMessage;
import com.smarthealth.repository.jpa.SiteContentRepository;
import com.smarthealth.repository.mongo.SiteFeatureRepository;
import com.smarthealth.service.ContactMessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class GuestController {

    @Autowired
    private SiteContentRepository siteContentRepository;

    @Autowired
    private SiteFeatureRepository siteFeatureRepository;

    @Autowired
    private ContactMessageService contactMessageService;

    @GetMapping("/")
    public String landingPage(Model model) {
        System.out.println("DEBUG: GuestController.landingPage() reached at /");
        model.addAttribute("siteContent", siteContentRepository.findFirstByOrderByIdAsc().orElse(null));
        model.addAttribute("features", siteFeatureRepository.findAll());
        return "landing";
    }

    @GetMapping("/auth/health")
    @org.springframework.web.bind.annotation.ResponseBody
    public String health() { return "OK"; }

    @GetMapping("/about")
    public String aboutPage(Model model) {
        model.addAttribute("siteContent", siteContentRepository.findFirstByOrderByIdAsc().orElse(null));
        return "about"; // Create about.jsp later
    }

    @GetMapping("/contact")
    public String contactPage(Model model) {
        model.addAttribute("siteContent", siteContentRepository.findFirstByOrderByIdAsc().orElse(null));
        return "contact"; // Create contact.jsp later
    }

    @PostMapping("/contact")
    public String contactSubmit(@RequestParam String fullName, @RequestParam String email,
                                @RequestParam String subject, @RequestParam String message,
                                RedirectAttributes ra) {
        ContactMessage contact = new ContactMessage();
        contact.setFullName(fullName);
        contact.setEmail(email);
        contact.setSubject(subject);
        contact.setMessage(message);
        
        contactMessageService.save(contact);
        ra.addFlashAttribute("success", "Your message has been sent successfully. We will get back to you soon.");
        return "redirect:/contact";
    }
}
