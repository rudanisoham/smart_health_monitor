package com.smarthealth.repository.jpa;

import com.smarthealth.model.Bed;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BedRepository extends JpaRepository<Bed, Long> {
    List<Bed> findByDepartmentId(Long departmentId);
    List<Bed> findByStatus(Bed.BedStatus status);
    List<Bed> findByDepartmentIdAndStatus(Long departmentId, Bed.BedStatus status);
    long countByDepartmentIdAndStatus(Long departmentId, Bed.BedStatus status);
    
    @Query("SELECT b FROM Bed b WHERE b.patient.id = :patientId")
    List<Bed> findByPatientId(@Param("patientId") Long patientId);
}
