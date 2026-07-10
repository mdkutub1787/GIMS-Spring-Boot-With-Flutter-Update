package com.kutub.InsuranceManagement.service.marine;

import com.kutub.InsuranceManagement.entity.marine.MarineBill;
import com.kutub.InsuranceManagement.entity.marine.MarinePolicy;
import com.kutub.InsuranceManagement.repository.marine.MarineBillRepository;
import com.kutub.InsuranceManagement.repository.marine.MarinePolicyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MarineBillService {

    @Autowired
    private MarineBillRepository billRepository;

    @Autowired
    private MarinePolicyRepository policyRepository;

    // Get all Marine Bills
    public List<MarineBill> getAllMarineBills() {
        return billRepository.findAll();
    }

    public MarineBill saveMarineBill(MarineBill bill) {
        // Fetch the related policy to ensure it's valid
        MarinePolicy marinePolicy = policyRepository.findById(bill.getMarineDetails().getId())
                .orElseThrow(() -> new RuntimeException("Policy not found with ID: " + bill.getMarineDetails().getId()));

        // Associate the policy with the bill
        bill.setMarineDetails(marinePolicy);

        // Perform premium calculations
        calculatePremiums(bill);

        // Save and return the bill
        return billRepository.save(bill);
    }

    // Update an existing Marine Bill with calculations
    public MarineBill updateMarineBill(MarineBill updatedBill, long id) {
        MarineBill existingBill = billRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Marine Bill not found with ID: " + id));

        // Update fields
        existingBill.setMarineRate(updatedBill.getMarineRate());
        existingBill.setWarSrccRate(updatedBill.getWarSrccRate());
        existingBill.setStampDuty(updatedBill.getStampDuty());

        // Recalculate net premium and gross premium
        calculatePremiums(existingBill);

        return billRepository.save(existingBill);
    }

    // Get Marine Bill by ID
    public MarineBill getMarineBillById(long id) {
        return billRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Marine Bill not found with ID: " + id));
    }

    // Delete Marine Bill by ID
    public void deleteMarineBill(long id) {
        billRepository.deleteById(id);
    }

    // Calculation method for premiums
    private void calculatePremiums(MarineBill bill) {
        double marineRate = bill.getMarineRate() / 100;
        double warSrccRate = bill.getWarSrccRate() / 100;
        double taxRate = 0.15; // Fixed tax rate of 15%

        // Get the sum insured from the related MarinePolicy
        double sumInsured = bill.getMarineDetails().getSumInsured();

        // Calculate net premium
        double netPremium = (sumInsured * marineRate) + (sumInsured * warSrccRate);
        bill.setNetPremium(roundToTwoDecimalPlaces(netPremium));

        // Calculate tax on net premium
        double tax = netPremium * taxRate;

        // Calculate gross premium
        double grossPremium = netPremium + tax + bill.getStampDuty();
        bill.setGrossPremium(roundToTwoDecimalPlaces(grossPremium));
    }

    // Method to round to two decimal places
    private double roundToTwoDecimalPlaces(double value) {
        return Math.round(value * 100.0) / 100.0;
    }

    // Update all bills when policy sumInsured changes
    public void updateBillsForMarinePolicy(MarinePolicy updatedPolicy) {
        // Fetch all bills linked to the given Marine Policy
        List<MarineBill> bills = billRepository.findMarineBillsByMarinePolicyId(updatedPolicy.getId());

        if (bills.isEmpty()) {
            return;
        }

        // Update each bill with the new policy details
        for (MarineBill bill : bills) {
            bill.setMarineDetails(updatedPolicy); // Update reference

            // Recalculate premium and other dependent fields
            calculatePremiums(bill);

            // Save the updated bill
            billRepository.save(bill);
        }
    }
}
