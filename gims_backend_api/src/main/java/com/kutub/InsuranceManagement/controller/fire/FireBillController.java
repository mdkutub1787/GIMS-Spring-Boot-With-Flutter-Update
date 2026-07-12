package com.kutub.InsuranceManagement.controller.fire;

import com.kutub.InsuranceManagement.entity.fire.FireBill;
import com.kutub.InsuranceManagement.entity.fire.FirePolicy;
import com.kutub.InsuranceManagement.model.ApiResponse;
import com.kutub.InsuranceManagement.service.fire.FireBillService;
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
@RequestMapping("api/bill")
@CrossOrigin(origins = "*")
public class FireBillController {

    @Autowired
    private FireBillService billService;

    private ResponseEntity<Object> dataNotFoundResponse() {
        Map<String, Object> failedResult = new LinkedHashMap<>();
        failedResult.put("status", "Failed");
        failedResult.put("msg", "Data Not Found");

        Map<String, Object> responseBody = new LinkedHashMap<>();
        responseBody.put("status", true);
        responseBody.put("resultset", failedResult);

        return ResponseEntity.ok(responseBody);
    }

    private Map<String, Object> createPolicyDetailsMap(FirePolicy policy) {
        Map<String, Object> policyDetails = new LinkedHashMap<>();
        policyDetails.put("policy_id", policy.getId());
        policyDetails.put("sys_number", policy.getSysNumber());

        Map<String, Object> companyMap = new LinkedHashMap<>();
        companyMap.put("id", policy.getCompany().getId());
        companyMap.put("name", policy.getCompany().getName());
        policyDetails.put("company", companyMap);

        policyDetails.put("date", policy.getDate());

        Map<String, Object> bankMap = new LinkedHashMap<>();
        bankMap.put("id", policy.getBank().getBnkKeyCode());
        bankMap.put("name", policy.getBank().getBank());
        policyDetails.put("bank", bankMap);

        if (policy.getBranch() != null) {
            Map<String, Object> branchMap = new LinkedHashMap<>();
            branchMap.put("id", policy.getBranch().getBrKeyCode());
            branchMap.put("name", policy.getBranch().getBranchName());
            policyDetails.put("branch", branchMap);
        } else {
            policyDetails.put("branch", null);
        }

        policyDetails.put("policyholder", policy.getPolicyholder());
        policyDetails.put("address", policy.getAddress());
        policyDetails.put("stock_insured", policy.getStockInsured());
        policyDetails.put("sum_insured", policy.getSumInsured());
        policyDetails.put("interest_insured", policy.getInterestInsured());
        policyDetails.put("coverage", policy.getCoverage());
        policyDetails.put("location", policy.getLocation());
        policyDetails.put("construction", policy.getConstruction());
        policyDetails.put("owner", policy.getOwner());
        policyDetails.put("used_as", policy.getUsedAs());
        policyDetails.put("period_from", policy.getPeriodFrom());
        policyDetails.put("period_to", policy.getPeriodTo());
        return policyDetails;
    }

    private List<Map<String, Object>> createBillDetailsList(List<FireBill> bills, FirePolicy policy) {
        return bills.stream().map(bill -> {
            Map<String, Object> billMap = new LinkedHashMap<>();
            billMap.put("billId", bill.getId());

            double sumInsured = policy.getSumInsured();
            double fireAmount = sumInsured * (bill.getFire() / 100.0);
            double rsdAmount = sumInsured * (bill.getRsd() / 100.0);
            double taxAmount = bill.getNetPremium() * (bill.getTax() / 100.0);

            Map<String, Object> fireDetails = new LinkedHashMap<>();
            fireDetails.put("percentage", bill.getFire());
            fireDetails.put("amount", fireAmount);
            billMap.put("fire", fireDetails);

            Map<String, Object> rsdDetails = new LinkedHashMap<>();
            rsdDetails.put("percentage", bill.getRsd());
            rsdDetails.put("amount", rsdAmount);
            billMap.put("rsd", rsdDetails);

            billMap.put("netPremium", bill.getNetPremium());

            Map<String, Object> taxDetails = new LinkedHashMap<>();
            taxDetails.put("percentage", bill.getTax());
            taxDetails.put("amount", taxAmount);
            billMap.put("tax", taxDetails);

            billMap.put("grossPremium", bill.getGrossPremium());
            return billMap;
        }).collect(Collectors.toList());
    }

    // Get all bills
    @GetMapping("/list")
    public ResponseEntity<Object> getAllBills() {
        List<FireBill> bills = billService.getAllBill();
        if (bills.isEmpty()) {
            return dataNotFoundResponse();
        }

        Map<FirePolicy, List<FireBill>> groupedByPolicy = bills.stream()
                .collect(Collectors.groupingBy(FireBill::getPolicy));

        List<Map<String, Object>> responseList = new ArrayList<>();
        for (Map.Entry<FirePolicy, List<FireBill>> entry : groupedByPolicy.entrySet()) {
            FirePolicy policy = entry.getKey();
            List<FireBill> policyBills = entry.getValue();

            Map<String, Object> policyDetails = createPolicyDetailsMap(policy);
            List<Map<String, Object>> billDetails = createBillDetailsList(policyBills, policy);

            Map<String, Object> resultset = new LinkedHashMap<>();
            resultset.put("PolicyDetails", policyDetails);
            resultset.put("BillDetails", billDetails);

            responseList.add(resultset);
        }

        return ResponseEntity.ok(ApiResponse.success(responseList));
    }

    // Save a new bill
    @PostMapping("/save")
    public ResponseEntity<ApiResponse<FireBill>> saveBill(@RequestBody FireBill b) {
        FireBill savedBill = billService.saveBill(b);
        return new ResponseEntity<>(ApiResponse.success(savedBill), HttpStatus.CREATED);
    }

    // Update an existing bill
    @PutMapping("/update/{id}")
    public ResponseEntity<ApiResponse<FireBill>> updateBill(@PathVariable int id, @RequestBody FireBill b) {
        try {
            FireBill updatedBill = billService.updateBill(b, id);
            return ResponseEntity.ok(ApiResponse.success(updatedBill));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse.error(e.getMessage()));
        }
    }

    // Delete a bill by ID
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<ApiResponse<Map<String, String>>> deleteBillById(@PathVariable int id) {
        try {
            billService.deleteBill(id);
            return ResponseEntity.ok(ApiResponse.success(Map.of("id", String.valueOf(id), "status", "deleted")));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse.error(e.getMessage()));
        }
    }

    // Get bill by ID
    @GetMapping("/{id}")
    public ResponseEntity<Object> getBillById(@PathVariable int id) {
        try {
            FireBill bill = billService.getBillById(id);
            return ResponseEntity.ok(ApiResponse.success(bill));
        } catch (RuntimeException e) {
            return dataNotFoundResponse();
        }
    }

    // Search bills by policyholder name
    @GetMapping("/searchpolicyholder")
    public ResponseEntity<Object> getBillsByPolicyholder(@RequestParam String policyholder) {
        List<FireBill> bills = billService.getBillsByPolicyholder(policyholder);
        if (bills.isEmpty()) {
            return dataNotFoundResponse();
        }
        return ResponseEntity.ok(ApiResponse.success(bills));
    }

    // Search bills by policy ID
    @GetMapping("/searchpolicyid")
    public ResponseEntity<Object> findBillsByPolicyId(@RequestParam("policyid") int policyid) {
        List<FireBill> bills = billService.findBillByPolicyId(policyid);
        if (bills.isEmpty()) {
            return dataNotFoundResponse();
        }
        return ResponseEntity.ok(ApiResponse.success(bills));
    }

    @GetMapping("/sysnumber/{sysNumber}")
    public ResponseEntity<Object> getBillsBySysNumber(@PathVariable String sysNumber) {
        try {
            List<FireBill> bills = billService.getBillsBySysNumber(sysNumber);
            if (bills.isEmpty()) {
                return dataNotFoundResponse();
            }

            Map<FirePolicy, List<FireBill>> groupedByPolicy = bills.stream()
                    .collect(Collectors.groupingBy(FireBill::getPolicy));

            List<Map<String, Object>> responseList = new ArrayList<>();
            for (Map.Entry<FirePolicy, List<FireBill>> entry : groupedByPolicy.entrySet()) {
                FirePolicy policy = entry.getKey();
                List<FireBill> policyBills = entry.getValue();

                Map<String, Object> policyDetails = createPolicyDetailsMap(policy);
                List<Map<String, Object>> billDetails = createBillDetailsList(policyBills, policy);

                Map<String, Object> resultset = new LinkedHashMap<>();
                resultset.put("PolicyDetails", policyDetails);
                resultset.put("BillDetails", billDetails);

                responseList.add(resultset);
            }

            return ResponseEntity.ok(ApiResponse.success(responseList));

        } catch (RuntimeException e) {
            return dataNotFoundResponse();
        }
    }
}
