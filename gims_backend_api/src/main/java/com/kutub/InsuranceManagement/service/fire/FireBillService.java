package com.kutub.InsuranceManagement.service.fire;

import com.kutub.InsuranceManagement.entity.fire.FireBill;
import com.kutub.InsuranceManagement.entity.fire.FirePolicy;
import com.kutub.InsuranceManagement.repository.fire.FireBillRepository;
import com.kutub.InsuranceManagement.repository.fire.FirePolicyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Calendar;
import java.util.List;

@Service
public class FireBillService {

    @Autowired
    private FireBillRepository billRepository;

    @Autowired
    private FirePolicyRepository policyRepository;


    // Get all Bills
    public List<FireBill> getAllBill() {
        return billRepository.findAll();
    }

    // Save a new Bill with calculations
    @Transactional
    public FireBill saveBill(FireBill bill) {
        // Fetch the related policy to ensure it's valid
        FirePolicy policy = policyRepository.findById(bill.getPolicy().getId())
                .orElseThrow(() -> new RuntimeException("Policy not found with ID: " + bill.getPolicy().getId()));

        // Generate sysNumber if it doesn't exist
        if (policy.getSysNumber() == null || policy.getSysNumber().isEmpty()) {
            policy.setSysNumber(generateSysNumber(policy));
            policy = policyRepository.save(policy); // Save the policy with the new sysNumber and get the managed instance
        }

        // Associate the policy with the bill
        bill.setPolicy(policy);

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

    private String generateSysNumber(FirePolicy policy) {
        String companyAcronym = getCompanyAcronym(policy.getCompany().getName());
        String insuranceType = "FI"; // For Fire insurance
        int year = Calendar.getInstance().get(Calendar.YEAR) % 100;
        // Use the policy's own ID for a unique and reliable number
        return companyAcronym + "-" + insuranceType + "-" + year + "-" + String.format("%05d", policy.getId());
    }

    // Update an existing Bill by ID
    @Transactional
    public FireBill updateBill(FireBill updatedBill, int id) {
        // Fetch the existing bill
        FireBill existingBill = billRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Bill not found with ID: " + id));

        // Update fields
        existingBill.setFire(updatedBill.getFire());
        existingBill.setRsd(updatedBill.getRsd());

        // Tax rate is fixed at 15%, no update needed

        // Recalculate premiums
        calculatePremiums(existingBill);

        // Save the updated bill
        return billRepository.save(existingBill);
    }

    // Delete a Bill by ID
    public void deleteBill(int id) {
        if (!billRepository.existsById(id)) {
            throw new RuntimeException("Bill not found with ID: " + id);
        }
        billRepository.deleteById(id);
    }

    // Get a Bill by its ID
    public FireBill getBillById(int id) {
        return billRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Bill not found with ID: " + id));
    }



    // Calculation method for premiums
    private void calculatePremiums(FireBill bill) {
        double fireRate = bill.getFire() / 100; // Fire rate in percentage
        double rsdRate = bill.getRsd() / 100;   // RSD rate in percentage
        double taxRate = bill.getTax() / 100;   // Tax rate in percentage

        // Get the sum insured from the related Policy
        double sumInsured = bill.getPolicy().getSumInsured();

        // Calculate net premium
        double netPremium = (sumInsured * fireRate) + (sumInsured * rsdRate);
        bill.setNetPremium(roundToTwoDecimalPlaces(netPremium));

        // Calculate tax on net premium
        double tax = netPremium * taxRate;

        // Calculate gross premium
        double grossPremium = netPremium + tax;
        bill.setGrossPremium(roundToTwoDecimalPlaces(grossPremium));
    }

    // Method to round to two decimal places
    private double roundToTwoDecimalPlaces(double value) {
        return Math.round(value * 100.0) / 100.0;
    }

    // Update all bills when policy sumInsured changes
    @Transactional
    public void updateBillsForPolicy(FirePolicy updatedPolicy) {
        // Fetch bills associated with the policy
        List<FireBill> bills = billRepository.findBillsByPolicyId(updatedPolicy.getId());

        // Update each bill
        for (FireBill bill : bills) {
            bill.setPolicy(updatedPolicy); // Update policy reference
            calculatePremiums(bill); // Recalculate premiums
            billRepository.save(bill); // Save the updated bill
        }
    }




    // Find bills by policyholder name
    public List<FireBill> getBillsByPolicyholder(String policyholder) {
        return billRepository.findBillsByPolicyholder(policyholder);
    }

    // Find bills by the associated policy ID
    public List<FireBill> findBillByPolicyId(int policyId) {
        return billRepository.findBillsByPolicyId(policyId);
    }

    public List<FireBill> getBillsBySysNumber(String sysNumber) {
        FirePolicy policy = policyRepository.findBySysNumber(sysNumber)
                .orElseThrow(() -> new RuntimeException("Policy not found with sysNumber: " + sysNumber));
        return billRepository.findBillsByPolicyId(policy.getId());
    }
}
