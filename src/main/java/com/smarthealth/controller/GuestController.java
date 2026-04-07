package com.smarthealth.controller;

import com.smarthealth.repository.jpa.SiteContentRepository;
import com.smarthealth.repository.mongo.SiteFeatureRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class GuestController {

    @Autowired
    private SiteContentRepository siteContentRepository;

    @Autowired
    private SiteFeatureRepository siteFeatureRepository;

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
}
