package com.smarthealth.service;

import com.smarthealth.model.Medicine;
import com.smarthealth.repository.jpa.MedicineRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class MedicineService {

    @Autowired
    private MedicineRepository medicineRepository;

    public Medicine save(Medicine medicine) {
        return medicineRepository.save(medicine);
    }

    public Optional<Medicine> findById(Long id) {
        return medicineRepository.findById(id);
    }

    public List<Medicine> findAll() {
        return medicineRepository.findByActiveTrue();
    }

    public List<Medicine> search(String query) {
        if (query == null || query.isBlank()) return findAll();
        return medicineRepository.search(query);
    }

    public List<Medicine> searchByName(String name) {
        return medicineRepository.findByNameContainingIgnoreCaseAndActiveTrue(name);
    }

    public boolean isDuplicate(String name, String dosageForm) {
        return medicineRepository.existsByNameIgnoreCaseAndDosageFormIgnoreCase(name, dosageForm);
    }

    public void deactivate(Long id) {
        medicineRepository.findById(id).ifPresent(m -> {
            m.setActive(false);
            medicineRepository.save(m);
        });
    }

    public long count() {
        return medicineRepository.findByActiveTrue().size();
    }
}
