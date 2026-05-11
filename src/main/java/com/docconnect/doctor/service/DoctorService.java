package com.docconnect.doctor.service;

import com.docconnect.doctor.model.dao.DoctorDAO;
import com.docconnect.specialization.model.dao.SpecializationDAO;
import com.docconnect.doctor.model.Doctor;
import com.docconnect.specialization.model.Specialization;

import java.math.BigDecimal;
import java.util.List;
import java.util.logging.Logger;

/**
 * Service layer for Doctor-related business logic.
 */
public class DoctorService {

    private static final Logger LOGGER = Logger.getLogger(DoctorService.class.getName());
    private final DoctorDAO doctorDAO = new DoctorDAO();
    private final SpecializationDAO specializationDAO = new SpecializationDAO();

    /**
     * Gets all active doctors.
     */
    public List<Doctor> getActiveDoctors(String sortBy) {
        return doctorDAO.findAllActive(sortBy);
    }

    /**
     * Gets all doctors (including inactive) for admin.
     */
    public List<Doctor> getAllDoctors() {
        return doctorDAO.findAll();
    }

    /**
     * Gets a doctor by ID.
     */
    public Doctor getDoctorById(int id) {
        return doctorDAO.findById(id);
    }

    /**
     * Searches doctors by keyword and/or specialization.
     */
    public List<Doctor> searchDoctors(String keyword, Integer specializationId, String sortBy) {
        return doctorDAO.search(keyword, specializationId, sortBy);
    }

    /**
     * Gets all specializations.
     */
    public List<Specialization> getAllSpecializations() {
        return specializationDAO.findAll();
    }

    /**
     * Gets a specialization by ID.
     */
    public Specialization getSpecializationById(int id) {
        return specializationDAO.findById(id);
    }

    /**
     * Creates a new specialization.
     */
    public String createSpecialization(Specialization spec) {
        if (spec.getName() == null || spec.getName().trim().isEmpty()) {
            return "Name is required.";
        }
        return specializationDAO.create(spec) ? null : "Failed to create specialization.";
    }

    /**
     * Updates an existing specialization.
     */
    public String updateSpecialization(Specialization spec) {
        if (spec.getName() == null || spec.getName().trim().isEmpty()) {
            return "Name is required.";
        }
        return specializationDAO.update(spec) ? null : "Failed to update specialization.";
    }

    /**
     * Deletes a specialization.
     */
    public boolean deleteSpecialization(int id) {
        return specializationDAO.delete(id);
    }

    /**
     * Creates a new doctor.
     *
     * @return error message or null on success
     */
    public String createDoctor(Doctor doctor) {
        String error = validateDoctor(doctor);
        if (error != null) return error;

        int id = doctorDAO.create(doctor);
        return id > 0 ? null : "Failed to create doctor.";
    }

    /**
     * Updates an existing doctor.
     *
     * @return error message or null on success
     */
    public String updateDoctor(Doctor doctor) {
        String error = validateDoctor(doctor);
        if (error != null) return error;

        return doctorDAO.update(doctor) ? null : "Failed to update doctor.";
    }

    /**
     * Deletes a doctor.
     */
    public boolean deleteDoctor(int id) {
        return doctorDAO.delete(id);
    }

    /**
     * Counts active doctors.
     */
    public int countActiveDoctors() {
        return doctorDAO.countActive();
    }

    /**
     * Gets doctors by specialization.
     */
    public List<Doctor> getDoctorsBySpecialization(int specializationId) {
        return doctorDAO.findBySpecialization(specializationId);
    }

    /**
     * Validates doctor data.
     */
    private String validateDoctor(Doctor doctor) {
        if (doctor.getFullName() == null || doctor.getFullName().trim().isEmpty()) {
            return "Doctor name is required.";
        }
        if (doctor.getSpecializationId() <= 0) {
            return "Please select a specialization.";
        }
        if (doctor.getQualification() == null || doctor.getQualification().trim().isEmpty()) {
            return "Qualification is required.";
        }
        if (doctor.getConsultationFee() == null || doctor.getConsultationFee().compareTo(BigDecimal.ZERO) <= 0) {
            return "Consultation fee must be greater than 0.";
        }
        if (doctor.getExperienceYears() < 0) {
            return "Experience years cannot be negative.";
        }
        return null;
    }
}
