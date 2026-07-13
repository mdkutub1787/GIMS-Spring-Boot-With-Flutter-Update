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
import java.util.LinkedHashMap;
import java.util.stream.Collectors;
import com.kutub.InsuranceManagement.entity.fire.FireBill;

@RestController
@RequestMapping("api/moneyreceipt")
@CrossOrigin(origins = "*")
public class FireMoneyReceiptController {
    
    @Autowired
    private FireMoneyReceiptService moneyReceiptService;

    // Get all Receipt
    @GetMapping("/list")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getAllMoneyReceipt() {
        List<FireMoneyReceipt> receipts = moneyReceiptService.getAllMoneyReceipt();
        
        List<Map<String, Object>> responseList = receipts.stream().map(receipt -> {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("id", receipt.getId());
            map.put("issuingOffice", receipt.getIssuingOffice());
            map.put("classOfInsurance", receipt.getClassOfInsurance());
            map.put("date", receipt.getDate());
            map.put("modeOfPayment", receipt.getModeOfPayment());
            map.put("issuedAgainst", receipt.getIssuedAgainst());
            
            if (receipt.getBill() != null) {
                FireBill bill = receipt.getBill();
                Map<String, Object> billMap = new LinkedHashMap<>();
                billMap.put("id", bill.getId());
                
                double sumInsured = bill.getPolicy() != null ? bill.getPolicy().getSumInsured() : 0.0;
                
                Map<String, Object> fireDetails = new LinkedHashMap<>();
                fireDetails.put("percentage", bill.getFire());
                fireDetails.put("amount", Math.round((sumInsured * (bill.getFire() / 100.0)) * 100.0) / 100.0);
                billMap.put("fire", fireDetails);
                
                Map<String, Object> rsdDetails = new LinkedHashMap<>();
                rsdDetails.put("percentage", bill.getRsd());
                rsdDetails.put("amount", Math.round((sumInsured * (bill.getRsd() / 100.0)) * 100.0) / 100.0);
                billMap.put("rsd", rsdDetails);
                
                Map<String, Object> taxDetails = new LinkedHashMap<>();
                taxDetails.put("percentage", bill.getTax());
                taxDetails.put("amount", Math.round((bill.getNetPremium() * (bill.getTax() / 100.0)) * 100.0) / 100.0);
                billMap.put("tax", taxDetails);
                
                billMap.put("netPremium", bill.getNetPremium());
                billMap.put("grossPremium", bill.getGrossPremium());
                billMap.put("policy", bill.getPolicy());
                
                map.put("bill", billMap);
            } else {
                map.put("bill", null);
            }
            return map;
        }).collect(Collectors.toList());
        
        return ResponseEntity.ok(ApiResponse.success(responseList));
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
