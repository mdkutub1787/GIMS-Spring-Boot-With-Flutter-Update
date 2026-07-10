package com.kutub.InsuranceManagement.service.fire;

import com.kutub.InsuranceManagement.entity.fire.FirePolicy;
import com.kutub.InsuranceManagement.repository.fire.FirePolicyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Calendar;

@Service
public class FirePolicyService {

    @Autowired
    private FirePolicyRepository policyRepository;

    @Autowired
    private FireBillService billService;

    // Fetch all policies
    public List<FirePolicy> getAllPolicy() {
        return policyRepository.findAll();
    }

    // Save a new policy
    public FirePolicy savePolicy(FirePolicy policy) {
        if (policy == null) {
            throw new IllegalArgumentException("Policy cannot be null.");
        }
        policy.setSysNumber(generateSysNumber());
        return policyRepository.save(policy);
    }

    private String generateSysNumber() {
        int year = Calendar.getInstance().get(Calendar.YEAR) % 100;
        long count = policyRepository.count();
        return "FAL-FPSR-" + year + "-" + String.format("%05d", count + 1);
    }

    // Find policy by ID
    public FirePolicy findById(int id) {
        return policyRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Policy not found with ID: " + id));
    }

    // Update an existing policy and update related bills
    public FirePolicy updatePolicy(FirePolicy updatedPolicy, int id) {
        // Fetch the existing policy
        FirePolicy existingPolicy = policyRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Policy not found with ID: " + id));

        // Update fields from the request
        existingPolicy.setCompany(updatedPolicy.getCompany());
        existingPolicy.setBankName(updatedPolicy.getBankName());
        existingPolicy.setBranchName(updatedPolicy.getBranchName());
        existingPolicy.setPolicyholder(updatedPolicy.getPolicyholder());
        existingPolicy.setAddress(updatedPolicy.getAddress());
        existingPolicy.setStockInsured(updatedPolicy.getStockInsured());
        existingPolicy.setSumInsured(updatedPolicy.getSumInsured());
        existingPolicy.setInterestInsured(updatedPolicy.getInterestInsured());
        existingPolicy.setCoverage(updatedPolicy.getCoverage());
        existingPolicy.setLocation(updatedPolicy.getLocation());
        existingPolicy.setConstruction(updatedPolicy.getConstruction());
        existingPolicy.setOwner(updatedPolicy.getOwner());
        existingPolicy.setUsedAs(updatedPolicy.getUsedAs());
        existingPolicy.setPeriodFrom(updatedPolicy.getPeriodFrom());

        // Save the updated policy
        FirePolicy savedPolicy = policyRepository.save(existingPolicy);

        // Trigger Bill updates if sumInsured is changed
        billService.updateBillsForPolicy(savedPolicy);

        return savedPolicy;
    }

    // Delete a policy by ID
    public void deletePolicy(int id) {
        if (!policyRepository.existsById(id)) {
            throw new RuntimeException("Policy not found with ID: " + id);
        }
        policyRepository.deleteById(id);
    }

    // Search policy by policyholder name
    public List<FirePolicy> searchPolicyByPolicyHolder(String policyholder) {
        List<FirePolicy> policies = policyRepository.findByPolicyHolder(policyholder);
        return policies.isEmpty() ? List.of() : policies;
    }

    // Search policies by bank name
    public List<FirePolicy> searchPolicyByBankName(String bankName) {
        List<FirePolicy> policies = policyRepository.findByBankName(bankName);
        return policies.isEmpty() ? List.of() : policies;
    }
}
