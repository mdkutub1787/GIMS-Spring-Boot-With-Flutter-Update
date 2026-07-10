package com.kutub.InsuranceManagement.controller.fire;

import com.kutub.InsuranceManagement.entity.fire.FireBill;
import com.kutub.InsuranceManagement.model.ApiResponse;
import com.kutub.InsuranceManagement.service.fire.FireBillService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("api/bill")
@CrossOrigin(origins = "*")
public class FireBillController {

    @Autowired
    private FireBillService billService;

    // Get all bills
    @GetMapping("/list")
    public ResponseEntity<ApiResponse<List<FireBill>>> getAllBills() {
        List<FireBill> bills = billService.getAllBill();
        return ResponseEntity.ok(ApiResponse.success(bills));
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
    public ResponseEntity<ApiResponse<FireBill>> getBillById(@PathVariable int id) {
        try {
            FireBill bill = billService.getBillById(id);
            return ResponseEntity.ok(ApiResponse.success(bill));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse.error(e.getMessage()));
        }
    }

    // Search bills by policyholder name
    @GetMapping("/searchpolicyholder")
    public ResponseEntity<ApiResponse<List<FireBill>>> getBillsByPolicyholder(@RequestParam String policyholder) {
        List<FireBill> bills = billService.getBillsByPolicyholder(policyholder);
        return ResponseEntity.ok(ApiResponse.success(bills));
    }

    // Search bills by policy ID
    @GetMapping("/searchpolicyid")
    public ResponseEntity<ApiResponse<List<FireBill>>> findBillsByPolicyId(@RequestParam("policyid") int policyid) {
        List<FireBill> bills = billService.findBillByPolicyId(policyid);
        return ResponseEntity.ok(ApiResponse.success(bills));
    }
}
