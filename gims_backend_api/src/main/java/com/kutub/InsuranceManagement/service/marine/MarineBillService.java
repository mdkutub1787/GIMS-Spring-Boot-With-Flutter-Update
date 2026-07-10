package com.kutub.InsuranceManagement.service.marine;

import com.kutub.InsuranceManagement.entity.marine.MarineBill;
import com.kutub.InsuranceManagement.entity.marine.MarinePolicy;
import com.kutub.InsuranceManagement.repository.marine.MarineBillRepository;
import com.kutub.InsuranceManagement.repository.marine.MarinePolicyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Calendar;
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

        // Generate sysNumber if it doesn't exist
        if (marinePolicy.getSysNumber() == null || marinePolicy.getSysNumber().isEmpty()) {
            marinePolicy.setSysNumber(generateSysNumber(marinePolicy));
            policyRepository.save(marinePolicy); // Save the policy with the new sysNumber
        }

        // Associate the policy with the bill
        bill.setMarineDetails(marinePolicy);

        // Perform premium calculations
        calculatePremiums(bill);

        // Save and return the bill
        return billRepository.save(bill);
    }

    private String getCompanyAcronym(String companyName) {
        if (companyName == null || companyName.isEmpty()) {
            return "DEFAULT";
        }
        // Remove content in parentheses and trim whitespace
        String nameWithoutParentheses = companyName.replaceAll("\\(.*?\\)", "").trim();
        StringBuilder acronym = new StringBuilder();
        // Split by one or more spaces
        for (String s : nameWithoutParentheses.split("\\s+")) {
            if (!s.isEmpty()) {
                acronym.append(s.charAt(0));
            }
        }
        return acronym.toString().toUpperCase();
    }

    private String generateSysNumber(MarinePolicy policy) {
        String companyAcronym = getCompanyAcronym(policy.getBank().getName()); // Assuming bank name is used for company
        String insuranceType = "MI"; // For Marine insurance
        int year = Calendar.getInstance().get(Calendar.YEAR) % 100;
        long count = policyRepository.count();
        return companyAcronym + "-" + insuranceType + "-" + year + "-" + String.format("%05d", count + 1);
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
