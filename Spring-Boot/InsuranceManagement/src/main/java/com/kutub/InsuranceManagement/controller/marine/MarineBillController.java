package com.kutub.InsuranceManagement.controller.marine;

import com.kutub.InsuranceManagement.entity.marine.MarineBill;
import com.kutub.InsuranceManagement.service.marine.MarineBillService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/marinebill")
@CrossOrigin(origins = "http://localhost:4200/")
public class MarineBillController {

    @Autowired
    private MarineBillService marineBillService;

    @GetMapping("/")
    public List<MarineBill> getAllBills() {
        return marineBillService.getAllMarineBills();
    }

    @PostMapping("/save")
    public void saveMarineBill(@RequestBody MarineBill mb) {
        marineBillService.saveMarineBill(mb);
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<String> updateMarineBill(@PathVariable int id, @RequestBody MarineBill mb) {
        try {
            marineBillService.updateMarineBill(mb, id);
            return ResponseEntity.ok("Marine Bill updated successfully.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    @DeleteMapping("/delete/{id}")
    public void deleteMarineBillById(@PathVariable long id) {
        marineBillService.deleteMarineBill(id);
    }

    // Get bill by ID
    @GetMapping("/{id}")
    public ResponseEntity<MarineBill> getMarineBillById(@PathVariable long id) {
        MarineBill mb = marineBillService.getMarineBillById(id);
        return ResponseEntity.ok(mb);
    }
}
