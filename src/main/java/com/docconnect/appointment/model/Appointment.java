package com.docconnect.appointment.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;

/**
 * Represents an appointment booking.
 */
public class Appointment {

    private int id;
    private int patientId;
    private int doctorId;
    private int slotId;
    private LocalDate appointmentDate;
    private String status; // confirmed, completed, cancelled, rescheduled
    private int turnNumber;
    private String notes;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Transient fields for display
    private String patientName;
    private String patientEmail;
    private String doctorName;
    private String specializationName;
    private String slotDay;
    private String slotTime;
    private String paymentStatus;
    private BigDecimal consultationFee;

    public Appointment() {
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }

    public int getSlotId() { return slotId; }
    public void setSlotId(int slotId) { this.slotId = slotId; }

    public LocalDate getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(LocalDate appointmentDate) { this.appointmentDate = appointmentDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getTurnNumber() { return turnNumber; }
    public void setTurnNumber(int turnNumber) { this.turnNumber = turnNumber; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public String getPatientEmail() { return patientEmail; }
    public void setPatientEmail(String patientEmail) { this.patientEmail = patientEmail; }

    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }

    public String getSpecializationName() { return specializationName; }
    public void setSpecializationName(String specializationName) { this.specializationName = specializationName; }

    public String getSlotDay() { return slotDay; }
    public void setSlotDay(String slotDay) { this.slotDay = slotDay; }

    public String getSlotTime() { return slotTime; }
    public void setSlotTime(String slotTime) { this.slotTime = slotTime; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public BigDecimal getConsultationFee() { return consultationFee; }
    public void setConsultationFee(BigDecimal consultationFee) { this.consultationFee = consultationFee; }

    public boolean isConfirmed() { return "confirmed".equals(status); }
    public boolean isCompleted() { return "completed".equals(status); }
    public boolean isCancelled() { return "cancelled".equals(status); }
    public boolean isRescheduled() { return "rescheduled".equals(status); }

    @Override
    public String toString() {
        return "Appointment{id=" + id + ", date=" + appointmentDate + ", status='" + status + "'}";
    }
}
