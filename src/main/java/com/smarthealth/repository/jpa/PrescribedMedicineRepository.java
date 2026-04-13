package com.smarthealth.repository.jpa;

import com.smarthealth.model.PrescribedMedicine;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PrescribedMedicineRepository extends JpaRepository<PrescribedMedicine, Long> {
    List<PrescribedMedicine> findByPrescriptionId(Long prescriptionId);
}
