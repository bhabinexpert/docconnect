package com.docconnect.slot.model;

import java.sql.Time;

/**
 * Represents a doctor's availability slot.
 */
public class Slot {

    private int id;
    private int doctorId;
    private String doctorName; // Transient field for display
    private String dayOfWeek;
    private java.time.LocalDate specificDate;
    private java.sql.Time startTime;
    private java.sql.Time endTime;
    private int maxPatients;
    private boolean isActive;

    public Slot() {
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }

    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }

    public String getDayOfWeek() { return dayOfWeek; }
    public void setDayOfWeek(String dayOfWeek) { this.dayOfWeek = dayOfWeek; }

    public java.time.LocalDate getSpecificDate() { return specificDate; }
    public void setSpecificDate(java.time.LocalDate specificDate) { this.specificDate = specificDate; }

    public Time getStartTime() { return startTime; }
    public void setStartTime(Time startTime) { this.startTime = startTime; }

    public Time getEndTime() { return endTime; }
    public void setEndTime(Time endTime) { this.endTime = endTime; }

    public int getMaxPatients() { return maxPatients; }
    public void setMaxPatients(int maxPatients) { this.maxPatients = maxPatients; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    /**
     * Returns formatted time range string (e.g., "09:00 - 09:30").
     */
    public String getFormattedTimeRange() {
        if (startTime != null && endTime != null) {
            return startTime.toString().substring(0, 5) + " - " + endTime.toString().substring(0, 5);
        }
        return "";
    }

    @Override
    public String toString() {
        return "Slot{id=" + id + ", dayOfWeek='" + dayOfWeek + "', time='" + getFormattedTimeRange() + "'}";
    }
}
