package com.smarthealth.repository.jpa;

import com.smarthealth.model.DoctorReview;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface DoctorReviewRepository extends JpaRepository<DoctorReview, Long> {
    @Query("SELECT r FROM DoctorReview r JOIN FETCH r.doctor d JOIN FETCH d.user JOIN FETCH r.patient p JOIN FETCH p.user ORDER BY r.createdAt DESC")
    List<DoctorReview> findAllWithDetails();

    List<DoctorReview> findByDoctorIdOrderByCreatedAtDesc(Long doctorId);

    boolean existsByAppointmentId(Long appointmentId);

    @Query("SELECT AVG(r.rating) FROM DoctorReview r WHERE r.doctor.id = :doctorId")
    Double getAverageRatingForDoctor(@Param("doctorId") Long doctorId);
    
    @Query("SELECT COUNT(r) FROM DoctorReview r WHERE r.doctor.id = :doctorId")
    Long getReviewCountForDoctor(@Param("doctorId") Long doctorId);
}
