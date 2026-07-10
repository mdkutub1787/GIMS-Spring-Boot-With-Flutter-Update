package com.kutub.InsuranceManagement.controller.marine;

import com.kutub.InsuranceManagement.entity.marine.MarineBill;
import com.kutub.InsuranceManagement.entity.marine.MarinePolicy;
import com.kutub.InsuranceManagement.model.ApiResponse;
import com.kutub.InsuranceManagement.service.marine.MarineBillService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("api/marinebill")
@CrossOrigin(origins = "*")
public class MarineBillController {

    @Autowired
    private MarineBillService marineBillService;

    private ResponseEntity<Object> dataNotFoundResponse() {
        Map<String, Object> failedResult = new LinkedHashMap<>();
        failedResult.put("status", "Failed");
        failedResult.put("msg", "Data Not Found");

        Map<String, Object> responseBody = new LinkedHashMap<>();
        responseBody.put("status", true);
        responseBody.put("resultset", failedResult);

        return ResponseEntity.ok(responseBody);
    }

    private Map<String, Object> createPolicyDetailsMap(MarinePolicy policy) {
        Map<String, Object> policyDetails = new LinkedHashMap<>();
        policyDetails.put("policy_id", policy.getId());
        policyDetails.put("sys_number", policy.getSysNumber());
        Map<String, Object> bankMap = new LinkedHashMap<>();
        bankMap.put("id", policy.getBank().getId());
        bankMap.put("name", policy.getBank().getName());
        policyDetails.put("bank", bankMap);
        policyDetails.put("date", policy.getDate());
        policyDetails.put("policyholder", policy.getPolicyholder());
        policyDetails.put("address", policy.getAddress());
        policyDetails.put("voyage_from", policy.getVoyageFrom());
        policyDetails.put("voyage_to", policy.getVoyageTo());
        policyDetails.put("via", policy.getVia());
        policyDetails.put("stock_item", policy.getStockItem());
        policyDetails.put("sum_insured_usd", policy.getSumInsuredUsd());
        policyDetails.put("usd_rate", policy.getUsdRate());
        policyDetails.put("sum_insured", policy.getSumInsured());
        policyDetails.put("coverage", policy.getCoverage());
        return policyDetails;
    }

    private List<Map<String, Object>> createBillDetailsList(List<MarineBill> bills, MarinePolicy policy) {
        return bills.stream().map(bill -> {
            Map<String, Object> billMap = new LinkedHashMap<>();
            billMap.put("billId", bill.getId());

            double sumInsured = policy.getSumInsured();
            double marineAmount = sumInsured * (bill.getMarineRate() / 100.0);
            double warSrccAmount = sumInsured * (bill.getWarSrccRate() / 100.0);

            Map<String, Object> marineDetails = new LinkedHashMap<>();
            marineDetails.put("percentage", bill.getMarineRate());
            marineDetails.put("amount", marineAmount);
            billMap.put("marine", marineDetails);

            Map<String, Object> warSrccDetails = new LinkedHashMap<>();
            warSrccDetails.put("percentage", bill.getWarSrccRate());
            warSrccDetails.put("amount", warSrccAmount);
            billMap.put("warSrcc", warSrccDetails);

            billMap.put("stampDuty", bill.getStampDuty());
            billMap.put("netPremium", bill.getNetPremium());
            billMap.put("grossPremium", bill.getGrossPremium());
            return billMap;
        }).collect(Collectors.toList());
    }

    @GetMapping("/list")
    public ResponseEntity<Object> getAllMarineBills() {
        List<MarineBill> bills = marineBillService.getAllMarineBills();
        if (bills.isEmpty()) {
            return dataNotFoundResponse();
        }

        Map<MarinePolicy, List<MarineBill>> groupedByPolicy = bills.stream()
                .collect(Collectors.groupingBy(MarineBill::getMarineDetails));

        List<Map<String, Object>> responseList = new ArrayList<>();
        for (Map.Entry<MarinePolicy, List<MarineBill>> entry : groupedByPolicy.entrySet()) {
            MarinePolicy policy = entry.getKey();
            List<MarineBill> policyBills = entry.getValue();

            Map<String, Object> policyDetails = createPolicyDetailsMap(policy);
            List<Map<String, Object>> billDetails = createBillDetailsList(policyBills, policy);

            Map<String, Object> resultset = new LinkedHashMap<>();
            resultset.put("PolicyDetails", policyDetails);
            resultset.put("BillDetails", billDetails);

            responseList.add(resultset);
        }

        return ResponseEntity.ok(ApiResponse.success(responseList));
    }

    @PostMapping("/save")
    public ResponseEntity<ApiResponse<MarineBill>> saveMarineBill(@RequestBody MarineBill mb) {
        MarineBill savedBill = marineBillService.saveMarineBill(mb);
        return new ResponseEntity<>(ApiResponse.success(savedBill), HttpStatus.CREATED);
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<Object> updateMarineBill(@PathVariable long id, @RequestBody MarineBill mb) {
        try {
            MarineBill updatedBill = marineBillService.updateMarineBill(mb, id);
            return ResponseEntity.ok(ApiResponse.success(updatedBill));
        } catch (RuntimeException e) {
            return dataNotFoundResponse();
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<ApiResponse<Map<String, String>>> deleteMarineBillById(@PathVariable long id) {
        try {
            marineBillService.deleteMarineBill(id);
            return ResponseEntity.ok(ApiResponse.success(Map.of("id", String.valueOf(id), "status", "deleted")));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse.error(e.getMessage()));
        }
    }

    // Get bill by ID
    @GetMapping("/{id}")
    public ResponseEntity<Object> getMarineBillById(@PathVariable long id) {
        try {
            MarineBill mb = marineBillService.getMarineBillById(id);
            return ResponseEntity.ok(ApiResponse.success(mb));
        } catch (RuntimeException e) {
            return dataNotFoundResponse();
        }
    }
}
