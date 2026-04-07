package com.smarthealth.model.mongo;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "site_features")
public class SiteFeature {

    @Id
    private String id;
    private String title;
    private String description;
    private String icon; // Bootstrap icon class name

    public SiteFeature() {}

    public SiteFeature(String title, String description, String icon) {
        this.title = title;
        this.description = description;
        this.icon = icon;
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }
}
