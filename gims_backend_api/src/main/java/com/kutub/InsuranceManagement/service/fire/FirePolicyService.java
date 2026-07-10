package com.kutub.InsuranceManagement.service.fire;

import com.kutub.InsuranceManagement.entity.fire.FirePolicy;
import com.kutub.InsuranceManagement.entity.utility.Bank;
import com.kutub.InsuranceManagement.entity.utility.Branch;
import com.kutub.InsuranceManagement.entity.utility.InsuranceCompany;
import com.kutub.InsuranceManagement.repository.fire.FirePolicyRepository;
import com.kutub.InsuranceManagement.repository.utility.BankRepository;
import com.kutub.InsuranceManagement.repository.utility.BranchRepository;
import com.kutub.InsuranceManagement.repository.utility.InsuranceCompanyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Calendar;

@Service
public class FirePolicyService {

    @Autowired
    private FirePolicyRepository policyRepository;

    @Autowired
    private FireBillService billService;

    @Autowired
    private InsuranceCompanyRepository insuranceCompanyRepository;

    @Autowired
    private BankRepository bankRepository;

    @Autowired
    private BranchRepository branchRepository;

    // Fetch all policies
    public List<FirePolicy> getAllPolicy() {
        return policyRepository.findAll();
    }

    // Save a new policy
    @Transactional
    public FirePolicy savePolicy(FirePolicy policy) {
        if (policy == null) {
            throw new IllegalArgumentException("Policy cannot be null.");
        }

        // Fetch and set the persistent InsuranceCompany instance
        if (policy.getCompany() != null && policy.getCompany().getId() != null) {
            InsuranceCompany company = insuranceCompanyRepository.findById(policy.getCompany().getId())
                    .orElseThrow(() -> new RuntimeException("InsuranceCompany not found with ID: " + policy.getCompany().getId()));
            policy.setCompany(company);
        }

        // Fetch and set the persistent Bank instance
        if (policy.getBank() != null && policy.getBank().getId() != null) {
            Bank bank = bankRepository.findById(policy.getBank().getId())
                    .orElseThrow(() -> new RuntimeException("Bank not found with ID: " + policy.getBank().getId()));
            policy.setBank(bank);
        }

        // Fetch and set the persistent Branch instance
        if (policy.getBranch() != null && policy.getBranch().getId() != null) {
            Branch branch = branchRepository.findById(policy.getBranch().getId())
                    .orElseThrow(() -> new RuntimeException("Branch not found with ID: " + policy.getBranch().getId()));
            policy.setBranch(branch);
        }

        // The sysNumber will now be generated when the bill is created.
        return policyRepository.save(policy);
    }

    // Find policy by ID
    public FirePolicy findById(int id) {
        return policyRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Policy not found with ID: " + id));
    }

    // Update an existing policy and update related bills
    @Transactional
    public FirePolicy updatePolicy(FirePolicy updatedPolicy, int id) {
        // Fetch the existing policy
        FirePolicy existingPolicy = policyRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Policy not found with ID: " + id));

        // Update fields from the request
        if (updatedPolicy.getCompany() != null && updatedPolicy.getCompany().getId() != null) {
            InsuranceCompany company = insuranceCompanyRepository.findById(updatedPolicy.getCompany().getId())
                    .orElseThrow(() -> new RuntimeException("InsuranceCompany not found with ID: " + updatedPolicy.getCompany().getId()));
            existingPolicy.setCompany(company);
        }

        if (updatedPolicy.getBank() != null && updatedPolicy.getBank().getId() != null) {
            Bank bank = bankRepository.findById(updatedPolicy.getBank().getId())
                    .orElseThrow(() -> new RuntimeException("Bank not found with ID: " + updatedPolicy.getBank().getId()));
            existingPolicy.setBank(bank);
        }

        if (updatedPolicy.getBranch() != null && updatedPolicy.getBranch().getId() != null) {
            Branch branch = branchRepository.findById(updatedPolicy.getBranch().getId())
                    .orElseThrow(() -> new RuntimeException("Branch not found with ID: " + updatedPolicy.getBranch().getId()));
            existingPolicy.setBranch(branch);
        }

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
        return policyRepository.findByBankName(bankName);
    }
}
