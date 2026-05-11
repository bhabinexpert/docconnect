package com.docconnect.specialization.model;

/**
 * Represents a medical specialization.
 */
public class Specialization {

    private int id;
    private String name;
    private String description;
    private String iconClass;

    public Specialization() {
    }

    public Specialization(int id, String name) {
        this.id = id;
        this.name = name;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getIconClass() { return iconClass; }
    public void setIconClass(String iconClass) { this.iconClass = iconClass; }

    @Override
    public String toString() {
        return "Specialization{id=" + id + ", name='" + name + "'}";
    }
}
