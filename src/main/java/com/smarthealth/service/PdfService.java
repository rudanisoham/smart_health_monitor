package com.smarthealth.service;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfWriter;
import com.smarthealth.model.Prescription;
import com.smarthealth.model.PrescribedMedicine;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;

@Service
public class PdfService {

    public byte[] generatePrescriptionPdf(Prescription prescription) throws DocumentException {
        Document document = new Document();
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        PdfWriter.getInstance(document, out);

        document.open();

        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
        Font subTitleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14);
        Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 12);

        // Header
        Paragraph title = new Paragraph("Smart Health Monitor - Prescription", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);
        document.add(Chunk.NEWLINE);

        // Details
        document.add(new Paragraph("Prescription ID: " + prescription.getId(), normalFont));
        document.add(new Paragraph("Doctor: Dr. " + prescription.getDoctor().getUser().getFullName(), normalFont));
        document.add(new Paragraph("Patient: " + prescription.getPatient().getUser().getFullName(), normalFont));
        document.add(new Paragraph("Date: " + prescription.getCreatedAt().toString().substring(0, 10), normalFont));
        document.add(new Paragraph("Valid Until: " + (prescription.getValidUntil() != null ? prescription.getValidUntil().toString() : "N/A"), normalFont));
        document.add(Chunk.NEWLINE);

        // Diagnosis
        document.add(new Paragraph("Diagnosis:", subTitleFont));
        document.add(new Paragraph(prescription.getDiagnosis(), normalFont));
        document.add(Chunk.NEWLINE);

        // Medicines
        document.add(new Paragraph("Prescribed Medicines:", subTitleFont));
        for (PrescribedMedicine pm : prescription.getPrescribedMedicinesList()) {
            document.add(new Paragraph("- " + pm.getMedicineName() + " | Dosage: " + pm.getDosage() + " | Timing: " + pm.getTiming() + " | Duration: " + pm.getDuration(), normalFont));
        }
        document.add(Chunk.NEWLINE);

        // Notes
        if (prescription.getNotes() != null && !prescription.getNotes().isEmpty()) {
            document.add(new Paragraph("Notes:", subTitleFont));
            document.add(new Paragraph(prescription.getNotes(), normalFont));
        }

        document.close();
        return out.toByteArray();
    }
}
