package com.kutub.InsuranceManagement.controller.fire;

import com.kutub.InsuranceManagement.entity.fire.FirePolicy;
import com.kutub.InsuranceManagement.model.ApiResponse;
import com.kutub.InsuranceManagement.service.fire.FirePolicyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("api/policy")
@CrossOrigin(origins = "*")
public class FirePolicyController {

    @Autowired
    private FirePolicyService policyService;

    @GetMapping("/list")
    public ResponseEntity<ApiResponse<List<FirePolicy>>> getAllPolicies() {
        List<FirePolicy> policies = policyService.getAllPolicy();
        return ResponseEntity.ok(ApiResponse.success(policies));
    }

    @PostMapping("/save")
    public ResponseEntity<ApiResponse<FirePolicy>> savePolicy(@RequestBody FirePolicy policy) {
        FirePolicy savedPolicy = policyService.savePolicy(policy);
        return new ResponseEntity<>(ApiResponse.success(savedPolicy), HttpStatus.CREATED);
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<ApiResponse<FirePolicy>> updatePolicy(@RequestBody FirePolicy policy, @PathVariable int id) {
        try {
            FirePolicy updatedPolicy = policyService.updatePolicy(policy, id);
            return ResponseEntity.ok(ApiResponse.success(updatedPolicy));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse.error(e.getMessage()));
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<ApiResponse<Map<String, String>>> deletePolicyById(@PathVariable int id) {
        try {
            policyService.deletePolicy(id);
            return ResponseEntity.ok(ApiResponse.success(Map.of("id", String.valueOf(id), "status", "deleted")));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse.error(e.getMessage()));
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<FirePolicy>> getPolicyById(@PathVariable int id) {
        try {
            FirePolicy policy = policyService.findById(id);
            return ResponseEntity.ok(ApiResponse.success(policy));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse.error(e.getMessage()));
        }
    }

    @GetMapping("/searchpolicyholder")
    public ResponseEntity<ApiResponse<List<FirePolicy>>> getPolicyByPolicyHolder(@RequestParam String policyholder) {
        List<FirePolicy> policies = policyService.searchPolicyByPolicyHolder(policyholder);
        return ResponseEntity.ok(ApiResponse.success(policies));
    }

    @GetMapping("/searchbankname")
    public ResponseEntity<ApiResponse<List<FirePolicy>>> getPolicyByBankName(@RequestParam String bankname) {
        List<FirePolicy> policies = policyService.searchPolicyByBankName(bankname);
        return ResponseEntity.ok(ApiResponse.success(policies));
    }
}
