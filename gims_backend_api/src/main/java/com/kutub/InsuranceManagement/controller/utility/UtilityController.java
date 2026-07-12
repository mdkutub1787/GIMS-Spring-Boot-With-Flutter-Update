package com.kutub.InsuranceManagement.controller.utility;

import com.kutub.InsuranceManagement.entity.utility.BnkInfo;
import com.kutub.InsuranceManagement.entity.utility.BnkBrInfo;
import com.kutub.InsuranceManagement.entity.utility.InsInfo;
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

    @GetMapping("/banks")
    public ResponseEntity<ApiResponse<List<BnkInfo>>> getAllBanks() {
        List<BnkInfo> banks = utilityService.getAllBanks();
        return ResponseEntity.ok(ApiResponse.success(banks));
    }

    @GetMapping("/banks/{bankId}/branches")
    public ResponseEntity<ApiResponse<List<BnkBrInfo>>> getBranchesByBankId(@PathVariable Integer bankId) {
        List<BnkBrInfo> branches = utilityService.getBranchesByBankId(bankId);
        return ResponseEntity.ok(ApiResponse.success(branches));
    }

    @GetMapping("/insurance-companies")
    public ResponseEntity<ApiResponse<List<InsInfo>>> getAllInsuranceCompanies() {
        List<InsInfo> companies = utilityService.getAllInsuranceCompanies();
        return ResponseEntity.ok(ApiResponse.success(companies));
    }
}
