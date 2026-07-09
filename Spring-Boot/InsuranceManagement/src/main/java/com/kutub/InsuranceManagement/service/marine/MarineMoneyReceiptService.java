package com.kutub.InsuranceManagement.service.marine;

import com.kutub.InsuranceManagement.entity.marine.MarineBill;
import com.kutub.InsuranceManagement.entity.marine.MarineMoneyReceipt;
import com.kutub.InsuranceManagement.repository.marine.MarineBillRepository;
import com.kutub.InsuranceManagement.repository.marine.MarineMoneyReceiptRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MarineMoneyReceiptService {

    @Autowired
    private MarineMoneyReceiptRepository moneyReceiptRepository;

    @Autowired
    private MarineBillRepository billRepository;

    // Retrieve all marine money receipts
    public List<MarineMoneyReceipt> getAllMarineMoneyReceipt() {
        return moneyReceiptRepository.findAll();
    }

    public MarineMoneyReceipt saveMarineMoneyReceipt(MarineMoneyReceipt receipt) {
        // Ensure that the marinebill is managed before saving the receipt
        MarineBill managedMarineBill = billRepository.findById(receipt.getMarinebill().getId())
                .orElseThrow(() -> new EntityNotFoundException("MarineBill not found with id: " + receipt.getMarinebill().getId()));

        // Attach the managed entity back to the receipt
        receipt.setMarinebill(managedMarineBill);

        // Now save the receipt
        return moneyReceiptRepository.save(receipt);
    }

    // Find a marine money receipt by ID
    public MarineMoneyReceipt findById(long id) {
        return moneyReceiptRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("MarineMoneyReceipt not found with id: " + id));
    }

    // Update an existing marine money receipt
    public void updateMarineMoneyReceipt(MarineMoneyReceipt updateMarineMoneyReceipt, long id) {
        // Fetch the existing MoneyReceipt from the database
        MarineMoneyReceipt existingMoneyReceipt = moneyReceiptRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("MoneyReceipt not found with ID: " + id));

        // Update the fields of the existing MoneyReceipt with values from the updated one
        existingMoneyReceipt.setIssuingOffice(updateMarineMoneyReceipt.getIssuingOffice());
        existingMoneyReceipt.setClassOfInsurance(updateMarineMoneyReceipt.getClassOfInsurance());

        // Only update the date if it's explicitly provided (null checks)
        if (updateMarineMoneyReceipt.getDate() != null) {
            existingMoneyReceipt.setDate(updateMarineMoneyReceipt.getDate());
        }

        existingMoneyReceipt.setModeOfPayment(updateMarineMoneyReceipt.getModeOfPayment());
        existingMoneyReceipt.setIssuedAgainst(updateMarineMoneyReceipt.getIssuedAgainst());

        // Check if Bill exists and set it, if necessary
        if (updateMarineMoneyReceipt.getMarinebill() != null && updateMarineMoneyReceipt.getMarinebill().getId() > 0) {
            MarineBill marinebill = billRepository.findById(updateMarineMoneyReceipt.getMarinebill().getId())
                    .orElseThrow(() -> new RuntimeException("Bill not found with ID: " + updateMarineMoneyReceipt.getMarinebill().getId()));

            // Set the existing marine bill on the MoneyReceipt
            existingMoneyReceipt.setMarinebill(marinebill);
        }

        // Save the updated MoneyReceipt
        moneyReceiptRepository.save(existingMoneyReceipt);
    }

    // Delete a marine money receipt by ID
    public void deleteMarineMoneyReceipt(long id) {
        if (!moneyReceiptRepository.existsById(id)) {
            throw new EntityNotFoundException("MarineMoneyReceipt not found with id: " + id);
        }
        moneyReceiptRepository.deleteById(id);
    }
}
