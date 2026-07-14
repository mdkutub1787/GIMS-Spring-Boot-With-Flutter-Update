package com.kutub.InsuranceManagement.controller.utility;

import com.kutub.InsuranceManagement.entity.utility.IssueOffice;
import com.kutub.InsuranceManagement.service.utility.IssueOfficeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/issue-offices")
@CrossOrigin(origins = "http://localhost:4200")
public class IssueOfficeController {

    @Autowired
    private IssueOfficeService issueOfficeService;

    @GetMapping
    public List<IssueOffice> getAllIssueOffices() {
        return issueOfficeService.getAllIssueOffices();
    }

    @PostMapping
    public ResponseEntity<IssueOffice> saveIssueOffice(@RequestBody IssueOffice issueOffice) {
        IssueOffice saved = issueOfficeService.saveIssueOffice(issueOffice);
        return ResponseEntity.ok(saved);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteIssueOffice(@PathVariable int id) {
        issueOfficeService.deleteIssueOffice(id);
        return ResponseEntity.ok().build();
    }
}
