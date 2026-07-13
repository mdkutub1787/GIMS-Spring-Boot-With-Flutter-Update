package com.kutub.InsuranceManagement.service.marine;

import com.kutub.InsuranceManagement.entity.marine.MarinePolicy;
import com.kutub.InsuranceManagement.repository.marine.MarinePolicyRepository;
import com.kutub.InsuranceManagement.service.common.CurrencyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MarinePolicyService {

    @Autowired
    private MarinePolicyRepository policyRepository;

    @Autowired
    private CurrencyService currencyService;

    @Autowired
    private MarineBillService billService;

    // Get all Marine policies
    public List<MarinePolicy> findAll() {
        return policyRepository.findAll();
    }

    public MarinePolicy saveMarinePolicy(MarinePolicy marinePolicy) {
        if (marinePolicy == null) {
            throw new IllegalArgumentException("Marine Policy cannot be null.");
        }
        double exchangeRate = currencyService.fetchExchangeRate().doubleValue();
        marinePolicy.convertSumInsuredUsd(exchangeRate);
        return policyRepository.save(marinePolicy);
    }

    // Update Marine Policy details and trigger related updates
    public MarinePolicy updateMarinePolicy(MarinePolicy updatedDetails, long id) {
        // Fetch the existing policy
        MarinePolicy existingPolicy = policyRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Marine Policy not found with ID: " + id));

        // Validate the updated details
        if (updatedDetails == null) {
            throw new IllegalArgumentException("Updated policy details cannot be null.");
        }

        // Update only changed fields
        boolean sumInsuredChanged = updatedDetails.getSumInsured() != existingPolicy.getSumInsured();

        if (sumInsuredChanged) {
            existingPolicy.setSumInsured(updatedDetails.getSumInsured());
        }

        if (updatedDetails.getSumInsuredUsd() != existingPolicy.getSumInsuredUsd()) {
            existingPolicy.setSumInsuredUsd(updatedDetails.getSumInsuredUsd());
        }

        if (updatedDetails.getPolicyholder() != null && !updatedDetails.getPolicyholder().equals(existingPolicy.getPolicyholder())) {
            existingPolicy.setPolicyholder(updatedDetails.getPolicyholder());
        }
        if (updatedDetails.getBranch() != null) {
            existingPolicy.setBranch(updatedDetails.getBranch());
        }
        if (updatedDetails.getBank() != null) {
            existingPolicy.setBank(updatedDetails.getBank());
        }
        if (updatedDetails.getAddress() != null) existingPolicy.setAddress(updatedDetails.getAddress());
        if (updatedDetails.getVoyageFrom() != null) existingPolicy.setVoyageFrom(updatedDetails.getVoyageFrom());
        if (updatedDetails.getVoyageTo() != null) existingPolicy.setVoyageTo(updatedDetails.getVoyageTo());
        if (updatedDetails.getVia() != null) existingPolicy.setVia(updatedDetails.getVia());
        if (updatedDetails.getStockItem() != null) existingPolicy.setStockItem(updatedDetails.getStockItem());
        if (updatedDetails.getCoverage() != null) existingPolicy.setCoverage(updatedDetails.getCoverage());

        // Save the updated policy
        MarinePolicy savedPolicy = policyRepository.save(existingPolicy);

        // Trigger related bill updates if sumInsured has changed
        if (sumInsuredChanged) {
            billService.updateBillsForMarinePolicy(savedPolicy);
        }

        return savedPolicy;
    }

    // Get Marine Policy by ID
    public MarinePolicy findById(long id) {
        return policyRepository.findById(id).orElse(null);
    }

    // Delete Marine Policy by ID
    public void deleteMarinePolicy(long id) {
        if (policyRepository.existsById(id)) {
            policyRepository.deleteById(id);
        } else {
            throw new IllegalArgumentException("Marine Policy with ID " + id + " does not exist");
        }
    }
}
