package com.kutub.InsuranceManagement.controller.marine;

import com.kutub.InsuranceManagement.entity.marine.MarinePolicy;
import com.kutub.InsuranceManagement.model.ApiResponse;
import com.kutub.InsuranceManagement.service.marine.MarinePolicyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("api/marine")
@CrossOrigin(origins = "*")
public class MarinePolicyController {

    @Autowired
    private MarinePolicyService marinePolicyService;

    private Map<String, Object> toPolicyMap(MarinePolicy policy) {
        Map<String, Object> policyMap = new LinkedHashMap<>();
        policyMap.put("policy_id", policy.getId());
        policyMap.put("sys_number", policy.getSysNumber());

        Map<String, Object> bankMap = new LinkedHashMap<>();
        bankMap.put("id", policy.getBank().getBnkKeyCode());
        bankMap.put("name", policy.getBank().getBank());
        policyMap.put("bank", bankMap);

        if (policy.getBranch() != null) {
            Map<String, Object> branchMap = new LinkedHashMap<>();
            branchMap.put("id", policy.getBranch().getBrKeyCode());
            branchMap.put("name", policy.getBranch().getBranchName());
            policyMap.put("branch", branchMap);
        }

        policyMap.put("date", policy.getDate());
        policyMap.put("policyholder", policy.getPolicyholder());
        policyMap.put("address", policy.getAddress());
        policyMap.put("voyage_from", policy.getVoyageFrom());
        policyMap.put("voyage_to", policy.getVoyageTo());
        policyMap.put("via", policy.getVia());
        policyMap.put("stock_item", policy.getStockItem());
        policyMap.put("sum_insured_usd", policy.getSumInsuredUsd());
        policyMap.put("usd_rate", policy.getUsdRate());
        policyMap.put("sum_insured", policy.getSumInsured());
        policyMap.put("coverage", policy.getCoverage());
        return policyMap;
    }

    // Get all Marine policies
    @GetMapping("/list")
    public ResponseEntity<Object> getAllMarinePolicies() {
        List<MarinePolicy> marinePolicies = marinePolicyService.findAll();
        if (marinePolicies.isEmpty()) {
            return createNotFoundResponse();
        }
        List<Map<String, Object>> customResponse = marinePolicies.stream()
                .map(this::toPolicyMap)
                .collect(Collectors.toList());
        return ResponseEntity.ok(ApiResponse.success(customResponse));
    }

    // Save new Marine policy
    @PostMapping("/save")
    public ResponseEntity<ApiResponse<MarinePolicy>> saveMarinePolicy(@RequestBody MarinePolicy marinePolicy) {
        MarinePolicy savedPolicy = marinePolicyService.saveMarinePolicy(marinePolicy);
        return new ResponseEntity<>(ApiResponse.success(savedPolicy), HttpStatus.CREATED);
    }

    // Update an existing policy
    @PutMapping("/update/{id}")
    public ResponseEntity<Object> updateMarinePolicy(
            @RequestBody MarinePolicy policy,
            @PathVariable long id) {
        try {
            MarinePolicy updatedPolicy = marinePolicyService.updateMarinePolicy(policy, id);
            return ResponseEntity.ok(ApiResponse.success(toPolicyMap(updatedPolicy)));
        } catch (RuntimeException e) {
            return createNotFoundResponse();
        }
    }

    // Get Marine policy by ID
    @GetMapping("/{id}")
    public ResponseEntity<Object> getMarinePolicyById(@PathVariable long id) {
        try {
            MarinePolicy marinePolicy = marinePolicyService.findById(id);
            return ResponseEntity.ok(ApiResponse.success(toPolicyMap(marinePolicy)));
        } catch (RuntimeException e) {
            return createNotFoundResponse();
        }
    }

    // Delete Marine policy by ID
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<ApiResponse<Map<String, String>>> deleteMarinePolicy(@PathVariable long id) {
        try {
            marinePolicyService.deleteMarinePolicy(id);
            return ResponseEntity.ok(ApiResponse.success(Map.of("id", String.valueOf(id), "status", "deleted")));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse.error(e.getMessage()));
        }
    }

    private ResponseEntity<Object> createNotFoundResponse() {
        Map<String, Object> failedResult = new LinkedHashMap<>();
        failedResult.put("status", "Failed");
        failedResult.put("msg", "Data Not Found");

        Map<String, Object> responseBody = new LinkedHashMap<>();
        responseBody.put("status", true);
        responseBody.put("resultset", failedResult);

        return ResponseEntity.ok(responseBody);
    }
}
