package com.smarthealth.repository.jpa;

import com.smarthealth.model.Medicine;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface MedicineRepository extends JpaRepository<Medicine, Long> {
    List<Medicine> findByActiveTrue();
    List<Medicine> findByNameContainingIgnoreCaseAndActiveTrue(String name);
    boolean existsByNameIgnoreCaseAndDosageFormIgnoreCase(String name, String dosageForm);

    @Query("SELECT m FROM Medicine m WHERE m.active = true AND " +
           "(LOWER(m.name) LIKE LOWER(CONCAT('%',:q,'%')) OR " +
           " LOWER(m.category) LIKE LOWER(CONCAT('%',:q,'%')))")
    List<Medicine> search(@Param("q") String query);
}
