package com.kutub.InsuranceManagement.controller.marine;

import com.kutub.InsuranceManagement.entity.marine.MarineMoneyReceipt;
import com.kutub.InsuranceManagement.service.marine.MarineMoneyReceiptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/marinemoneyreceipt")
@CrossOrigin(origins = "http://localhost:4200/")
public class MarineMoneyReceiptController {

    private final MarineMoneyReceiptService marineMoneyReceiptService;

    // Constructor-based Dependency Injection
    @Autowired
    public MarineMoneyReceiptController(MarineMoneyReceiptService marineMoneyReceiptService) {
        this.marineMoneyReceiptService = marineMoneyReceiptService;
    }

    // Get all receipts
    @GetMapping("/")
    public ResponseEntity<List<MarineMoneyReceipt>> getAllMarineMoneyReceipt() {
        List<MarineMoneyReceipt> receipts = marineMoneyReceiptService.getAllMarineMoneyReceipt();
        return ResponseEntity.ok(receipts);
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
