package com.kutub.InsuranceManagement.controller.fire;

import com.kutub.InsuranceManagement.entity.fire.FireMoneyReceipt;
import com.kutub.InsuranceManagement.model.ApiResponse;
import com.kutub.InsuranceManagement.service.fire.FireMoneyReceiptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("api/moneyreceipt")
@CrossOrigin(origins = "*")
public class FireMoneyReceiptController {
    
    @Autowired
    private FireMoneyReceiptService moneyReceiptService;

    // Get all Receipt
    @GetMapping("/list")
    public ResponseEntity<ApiResponse<List<FireMoneyReceipt>>> getAllMoneyReceipt() {
        List<FireMoneyReceipt> receipts = moneyReceiptService.getAllMoneyReceipt();
        return ResponseEntity.ok(ApiResponse.success(receipts));
    }

    // Create a new Receipt
    @PostMapping("/save")
    public ResponseEntity<ApiResponse<FireMoneyReceipt>> saveMoneyReceipt(@RequestBody FireMoneyReceipt mr) {
        FireMoneyReceipt savedReceipt = moneyReceiptService.saveMoneyReceipt(mr);
        return new ResponseEntity<>(ApiResponse.success(savedReceipt), HttpStatus.CREATED);
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<ApiResponse<FireMoneyReceipt>> updateMoneyReceipt(@PathVariable int id, @RequestBody FireMoneyReceipt mr) {
        try {
            FireMoneyReceipt updatedReceipt = moneyReceiptService.updateMoneyReceipt(mr, id);
            return ResponseEntity.ok(ApiResponse.success(updatedReceipt));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse.error(e.getMessage()));
        }
    }

    // Delete a Receipt by ID
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<ApiResponse<Map<String, String>>> deleteMoneyReceiptById(@PathVariable int id) {
        try {
            moneyReceiptService.deleteMoneyReceipt(id);
            return ResponseEntity.ok(ApiResponse.success(Map.of("id", String.valueOf(id), "status", "deleted")));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse.error(e.getMessage()));
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<FireMoneyReceipt>> getMoneyReceiptById(@PathVariable int id) {
        try {
            FireMoneyReceipt mr = moneyReceiptService.getMoneyReceiptById(id);
            return ResponseEntity.ok(ApiResponse.success(mr));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse.error(e.getMessage()));
        }
    }
}
