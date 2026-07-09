package com.kutub.InsuranceManagement.controller.utility;

import com.kutub.InsuranceManagement.entity.utility.Bank;
import com.kutub.InsuranceManagement.entity.utility.Branch;
import com.kutub.InsuranceManagement.entity.utility.InsuranceCompany;
import com.kutub.InsuranceManagement.model.ApiResponse;
import com.kutub.InsuranceManagement.service.utility.UtilityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api")
@CrossOrigin(origins = "*")
public class UtilityController {

    @Autowired
    private UtilityService utilityService;

    @GetMapping("/banks") // নতুন RESTful এন্ডপয়েন্ট
    public ResponseEntity<ApiResponse<List<Bank>>> getAllBanks() {
        List<Bank> banks = utilityService.getAllBanks();
        return ResponseEntity.ok(ApiResponse.success(banks));
    }

    @GetMapping("/banks/{bankId}/branches") // নতুন RESTful এন্ডপয়েন্ট
    public ResponseEntity<ApiResponse<List<Branch>>> getBranchesByBankId(@PathVariable Long bankId) {
        List<Branch> branches = utilityService.getBranchesByBankId(bankId);
        return ResponseEntity.ok(ApiResponse.success(branches));
    }

    @GetMapping("/insurance-companies")
    public ResponseEntity<ApiResponse<List<InsuranceCompany>>> getAllInsuranceCompanies() {
        List<InsuranceCompany> companies = utilityService.getAllInsuranceCompanies();
        return ResponseEntity.ok(ApiResponse.success(companies));
    }
}
