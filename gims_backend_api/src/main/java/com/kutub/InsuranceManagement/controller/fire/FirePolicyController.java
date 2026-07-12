package com.kutub.InsuranceManagement.controller.fire;

import com.kutub.InsuranceManagement.entity.fire.FirePolicy;
import com.kutub.InsuranceManagement.model.ApiResponse;
import com.kutub.InsuranceManagement.service.fire.FirePolicyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("api/policy")
@CrossOrigin(origins = "*")
public class FirePolicyController {

    @Autowired
    private FirePolicyService policyService;

    private Map<String, Object> toPolicyMap(FirePolicy policy) {
        Map<String, Object> policyMap = new LinkedHashMap<>();
        policyMap.put("policy_id", policy.getId());

        Map<String, Object> companyMap = new LinkedHashMap<>();
        companyMap.put("id", policy.getCompany().getId());
        companyMap.put("name", policy.getCompany().getName());
        policyMap.put("company", companyMap);

        policyMap.put("date", policy.getDate());

        Map<String, Object> bankMap = new LinkedHashMap<>();
        bankMap.put("id", policy.getBank().getBnkKeyCode());
        bankMap.put("name", policy.getBank().getBank());
        policyMap.put("bank", bankMap);

        if (policy.getBranch() != null) {
            Map<String, Object> branchMap = new LinkedHashMap<>();
            branchMap.put("id", policy.getBranch().getBrKeyCode());
            branchMap.put("name", policy.getBranch().getBranchName());
            policyMap.put("branch", branchMap);
        } else {
            policyMap.put("branch", null);
        }

        policyMap.put("policyholder", policy.getPolicyholder());
        policyMap.put("address", policy.getAddress());
        policyMap.put("stock_insured", policy.getStockInsured());
        policyMap.put("sum_insured", policy.getSumInsured());
        policyMap.put("interest_insured", policy.getInterestInsured());
        policyMap.put("coverage", policy.getCoverage());
        policyMap.put("location", policy.getLocation());
        policyMap.put("construction", policy.getConstruction());
        policyMap.put("owner", policy.getOwner());
        policyMap.put("used_as", policy.getUsedAs());
        policyMap.put("period_from", policy.getPeriodFrom());
        policyMap.put("period_to", policy.getPeriodTo());
        return policyMap;
    }

    @GetMapping("/list")
    public ResponseEntity<Object> getAllPolicies() {
        List<FirePolicy> policies = policyService.getAllPolicy();
        if (policies.isEmpty()) {
            return createNotFoundResponse();
        }
        List<Map<String, Object>> customResponse = policies.stream()
                .map(this::toPolicyMap)
                .collect(Collectors.toList());
        return ResponseEntity.ok(ApiResponse.success(customResponse));
    }

    @PostMapping("/save")
    public ResponseEntity<ApiResponse<FirePolicy>> savePolicy(@RequestBody FirePolicy policy) {
        FirePolicy savedPolicy = policyService.savePolicy(policy);
        return new ResponseEntity<>(ApiResponse.success(savedPolicy), HttpStatus.CREATED);
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<Object> updatePolicy(@RequestBody FirePolicy policy, @PathVariable int id) {
        try {
            FirePolicy updatedPolicy = policyService.updatePolicy(policy, id);
            return ResponseEntity.ok(ApiResponse.success(toPolicyMap(updatedPolicy)));
        } catch (RuntimeException e) {
            return createNotFoundResponse();
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Object> deletePolicyById(@PathVariable int id) {
        try {
            policyService.deletePolicy(id);
            return ResponseEntity.ok(ApiResponse.success(Map.of("id", String.valueOf(id), "status", "deleted")));
        } catch (RuntimeException e) {
            return createNotFoundResponse();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<Object> getPolicyById(@PathVariable int id) {
        try {
            FirePolicy policy = policyService.findById(id);
            return ResponseEntity.ok(ApiResponse.success(toPolicyMap(policy)));
        } catch (RuntimeException e) {
            return createNotFoundResponse();
        }
    }

    @GetMapping("/searchpolicyholder")
    public ResponseEntity<Object> getPolicyByPolicyHolder(@RequestParam String policyholder) {
        List<FirePolicy> policies = policyService.searchPolicyByPolicyHolder(policyholder);
        if (policies.isEmpty()) {
            return createNotFoundResponse();
        }
        List<Map<String, Object>> customResponse = policies.stream()
                .map(this::toPolicyMap)
                .collect(Collectors.toList());
        return ResponseEntity.ok(ApiResponse.success(customResponse));
    }

    @GetMapping("/searchbankname")
    public ResponseEntity<Object> getPolicyByBankName(@RequestParam String bankname) {
        List<FirePolicy> policies = policyService.searchPolicyByBankName(bankname);
        if (policies.isEmpty()) {
            return createNotFoundResponse();
        }
        List<Map<String, Object>> customResponse = policies.stream()
                .map(this::toPolicyMap)
                .collect(Collectors.toList());
        return ResponseEntity.ok(ApiResponse.success(customResponse));
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
