package com.kutub.InsuranceManagement.service.fire;

import com.kutub.InsuranceManagement.entity.fire.FireBill;
import com.kutub.InsuranceManagement.entity.fire.FireMoneyReceipt;
import com.kutub.InsuranceManagement.repository.fire.FireBillRepository;
import com.kutub.InsuranceManagement.repository.fire.FireMoneyReceiptRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FireMoneyReceiptService {

    @Autowired
    private FireMoneyReceiptRepository moneyReceiptRepository;

    @Autowired
    private FireBillRepository billRepository;

    public List<FireMoneyReceipt> getAllMoneyReceipt() {
        return  moneyReceiptRepository.findAll();
    }

    public void saveMoneyReceipt(FireMoneyReceipt mr) {
            FireBill bill = billRepository.findById(mr.getBill().getId())
                    .orElseThrow(
                            () -> new RuntimeException("Bill not found " + mr.getBill().getId())
                    );
            mr.setBill(bill);
            moneyReceiptRepository.save(mr);
        }


    public FireMoneyReceipt getMoneyReceiptById(int id) {
        return moneyReceiptRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("MoneyReceipt not found with ID: " + id));
    }

    public void deleteMoneyReceipt(int id) {
        moneyReceiptRepository.deleteById(id);
    }

    public void updateMoneyReceipt(FireMoneyReceipt updatedMoneyReceipt, int id) {
        // Fetch the existing MoneyReceipt from the database
        FireMoneyReceipt existingMoneyReceipt = moneyReceiptRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("MoneyReceipt not found with ID: " + id));

        // Update the fields of the existing MoneyReceipt with values from the updated one
        existingMoneyReceipt.setIssuingOffice(updatedMoneyReceipt.getIssuingOffice());
        existingMoneyReceipt.setClassOfInsurance(updatedMoneyReceipt.getClassOfInsurance());
        existingMoneyReceipt.setDate(updatedMoneyReceipt.getDate());
        existingMoneyReceipt.setModeOfPayment(updatedMoneyReceipt.getModeOfPayment());
        existingMoneyReceipt.setIssuedAgainst(updatedMoneyReceipt.getIssuedAgainst());

        // Check if Bill exists and set it, if necessary
        if (updatedMoneyReceipt.getBill() != null) {
            FireBill bill = billRepository.findById(updatedMoneyReceipt.getBill().getId())
                    .orElseThrow(() -> new RuntimeException("Bill not found with ID: " + updatedMoneyReceipt.getBill().getId()));
            existingMoneyReceipt.setBill(bill);
        }

        // Save the updated MoneyReceipt
        moneyReceiptRepository.save(existingMoneyReceipt);
    }
}
