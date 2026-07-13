package com.kutub.InsuranceManagement.controller.marine;

import com.kutub.InsuranceManagement.entity.marine.MarineMoneyReceipt;
import com.kutub.InsuranceManagement.service.marine.MarineMoneyReceiptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;
import java.util.stream.Collectors;
import com.kutub.InsuranceManagement.entity.marine.MarineBill;
@RestController
@RequestMapping("api/marinemoneyreceipt")
@CrossOrigin(origins = "*")
public class MarineMoneyReceiptController {

    private final MarineMoneyReceiptService marineMoneyReceiptService;

    // Constructor-based Dependency Injection
    @Autowired
    public MarineMoneyReceiptController(MarineMoneyReceiptService marineMoneyReceiptService) {
        this.marineMoneyReceiptService = marineMoneyReceiptService;
    }


    // Get all receipts
    @GetMapping("/list")
    public ResponseEntity<List<Map<String, Object>>> getAllMarineMoneyReceipt() {
        List<MarineMoneyReceipt> receipts = marineMoneyReceiptService.getAllMarineMoneyReceipt();
        
        List<Map<String, Object>> responseList = receipts.stream().map(receipt -> {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("id", receipt.getId());
            map.put("issuingOffice", receipt.getIssuingOffice());
            map.put("classOfInsurance", receipt.getClassOfInsurance());
            map.put("date", receipt.getDate());
            map.put("modeOfPayment", receipt.getModeOfPayment());
            map.put("issuedAgainst", receipt.getIssuedAgainst());
            
            if (receipt.getMarinebill() != null) {
                MarineBill bill = receipt.getMarinebill();
                Map<String, Object> billMap = new LinkedHashMap<>();
                billMap.put("id", bill.getId());
                
                double sumInsured = bill.getMarineDetails() != null ? bill.getMarineDetails().getSumInsured() : 0.0;
                
                Map<String, Object> marineDetails = new LinkedHashMap<>();
                marineDetails.put("percentage", bill.getMarineRate());
                marineDetails.put("amount", Math.round((sumInsured * (bill.getMarineRate() / 100.0)) * 100.0) / 100.0);
                billMap.put("marine", marineDetails);
                
                Map<String, Object> warSrccDetails = new LinkedHashMap<>();
                warSrccDetails.put("percentage", bill.getWarSrccRate());
                warSrccDetails.put("amount", Math.round((sumInsured * (bill.getWarSrccRate() / 100.0)) * 100.0) / 100.0);
                billMap.put("warSrcc", warSrccDetails);
                
                Map<String, Object> taxDetails = new LinkedHashMap<>();
                taxDetails.put("percentage", bill.getTax());
                taxDetails.put("amount", Math.round((bill.getNetPremium() * (bill.getTax() / 100.0)) * 100.0) / 100.0);
                billMap.put("tax", taxDetails);
                
                billMap.put("netPremium", bill.getNetPremium());
                billMap.put("stampDuty", bill.getStampDuty());
                billMap.put("grossPremium", bill.getGrossPremium());
                billMap.put("marineDetails", bill.getMarineDetails());
                
                map.put("marinebill", billMap);
            } else {
                map.put("marinebill", null);
            }
            return map;
        }).collect(Collectors.toList());
        
        return ResponseEntity.ok(responseList);
    }

    // Create a new receipt
    @PostMapping("/save")
    public ResponseEntity<MarineMoneyReceipt> saveMarineMoneyReceipt(@RequestBody MarineMoneyReceipt mr) {
        MarineMoneyReceipt savedReceipt = marineMoneyReceiptService.saveMarineMoneyReceipt(mr);
        return new ResponseEntity<>(savedReceipt, HttpStatus.CREATED);
    }

    // Update an existing receipt
    @PutMapping("/update/{id}")
    public ResponseEntity<String> updateMarineMoneyReceipt(@PathVariable long id, @RequestBody MarineMoneyReceipt mr) {
        try {
            marineMoneyReceiptService.updateMarineMoneyReceipt(mr, id);
            return ResponseEntity.ok("Marine Money Receipt updated successfully.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    // Delete a receipt by ID
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Void> deleteMarineMoneyReceiptById(@PathVariable long id) {
        marineMoneyReceiptService.deleteMarineMoneyReceipt(id);
        return ResponseEntity.noContent().build(); // Returns 204 No Content
    }

    // Get a specific receipt by ID
    @GetMapping("/{id}")
    public ResponseEntity<MarineMoneyReceipt> getMarineMoneyReceiptById(@PathVariable long id) {
        MarineMoneyReceipt receipt = marineMoneyReceiptService.findById(id);
        return ResponseEntity.ok(receipt);
    }
}
