package com.smarthealth.service;

import com.smarthealth.model.DoctorReview;
import com.smarthealth.repository.jpa.DoctorReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class DoctorReviewService {

    @Autowired
    private DoctorReviewRepository reviewRepository;

    public DoctorReview save(DoctorReview review) {
        return reviewRepository.save(review);
    }

    public List<DoctorReview> findAll() {
        return reviewRepository.findAllWithDetails();
    }


    public List<DoctorReview> findByDoctorId(Long doctorId) {
        return reviewRepository.findByDoctorIdOrderByCreatedAtDesc(doctorId);
    }

    public boolean hasReviewedAppointment(Long appointmentId) {
        return reviewRepository.existsByAppointmentId(appointmentId);
    }

    public Double getAverageRating(Long doctorId) {
        return reviewRepository.getAverageRatingForDoctor(doctorId);
    }

    public Long getReviewCount(Long doctorId) {
        return reviewRepository.getReviewCountForDoctor(doctorId);
    }
}
