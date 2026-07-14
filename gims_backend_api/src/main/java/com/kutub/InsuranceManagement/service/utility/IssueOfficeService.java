package com.kutub.InsuranceManagement.service.utility;

import com.kutub.InsuranceManagement.entity.utility.IssueOffice;
import com.kutub.InsuranceManagement.repository.utility.IssueOfficeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class IssueOfficeService {

    @Autowired
    private IssueOfficeRepository issueOfficeRepository;

    public List<IssueOffice> getAllIssueOffices() {
        return issueOfficeRepository.findAll();
    }

    public IssueOffice saveIssueOffice(IssueOffice issueOffice) {
        return issueOfficeRepository.save(issueOffice);
    }

    public void deleteIssueOffice(int id) {
        issueOfficeRepository.deleteById(id);
    }
}
