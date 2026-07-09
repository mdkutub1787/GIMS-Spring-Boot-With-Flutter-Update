package com.kutub.InsuranceManagement.controller.marine;

import com.kutub.InsuranceManagement.entity.marine.MarinePolicy;
import com.kutub.InsuranceManagement.model.ApiResponse;
import com.kutub.InsuranceManagement.service.marine.MarinePolicyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("api/marine")
@CrossOrigin(origins = "*")
public class MarinePolicyController {

    @Autowired
    private MarinePolicyService marinePolicyService;

    // Get all Marine policies
    @GetMapping("/list")
    public ResponseEntity<ApiResponse<List<MarinePolicy>>> getAllMarinePolicies() {
        List<MarinePolicy> marinePolicies = marinePolicyService.findAll();
        return ResponseEntity.ok(ApiResponse.success(marinePolicies));
    }

    // Save new Marine policy
    @PostMapping("/save")
    public ResponseEntity<ApiResponse<MarinePolicy>> saveMarinePolicy(@RequestBody MarinePolicy marinePolicy) {
        MarinePolicy savedPolicy = marinePolicyService.saveMarinePolicy(marinePolicy);
        return new ResponseEntity<>(ApiResponse.success(savedPolicy), HttpStatus.CREATED);
    }

    // Update an existing policy
    @PutMapping("/update/{id}")
    public ResponseEntity<ApiResponse<MarinePolicy>> updateMarinePolicy(
            @RequestBody MarinePolicy policy,
            @PathVariable long id) {
        try {
            MarinePolicy updatedPolicy = marinePolicyService.updateMarinePolicy(policy, id);
            return ResponseEntity.ok(ApiResponse.success(updatedPolicy));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse.error(e.getMessage()));
        }
    }

    // Get Marine policy by ID
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<MarinePolicy>> getMarinePolicyById(@PathVariable long id) {
        try {
            MarinePolicy marinePolicy = marinePolicyService.findById(id);
            return ResponseEntity.ok(ApiResponse.success(marinePolicy));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse.error(e.getMessage()));
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
}
