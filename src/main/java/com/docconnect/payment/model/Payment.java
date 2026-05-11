package com.docconnect.payment.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Represents a payment record for an appointment.
 */
public class Payment {

    private int id;
    private int appointmentId;
    private BigDecimal amount;
    private String paymentMethod; // khalti, esewa
    private String transactionId;
    private String status; // pending, completed, failed, refunded
    private Timestamp paidAt;
    private Timestamp createdAt;

    // Transient fields for display
    private String patientName;
    private String doctorName;
    private String appointmentDate;

    public Payment() {
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getPaidAt() { return paidAt; }
    public void setPaidAt(Timestamp paidAt) { this.paidAt = paidAt; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }

    public String getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(String appointmentDate) { this.appointmentDate = appointmentDate; }

    public boolean isCompleted() { return "completed".equals(status); }
    public boolean isPending() { return "pending".equals(status); }

    @Override
    public String toString() {
        return "Payment{id=" + id + ", appointmentId=" + appointmentId + ", method='" + paymentMethod + "', status='" + status + "'}";
    }
}
