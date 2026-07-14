package com.kutub.InsuranceManagement.config;

import com.kutub.InsuranceManagement.entity.utility.IssueOffice;
import com.kutub.InsuranceManagement.repository.utility.IssueOfficeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class DataSeeder implements CommandLineRunner {

    @Autowired
    private IssueOfficeRepository issueOfficeRepository;

    @Override
    public void run(String... args) throws Exception {
        if (issueOfficeRepository.count() == 0) {
            IssueOffice headOffice = new IssueOffice();
            headOffice.setName("Head Office, Dhaka");
            headOffice.setAddress("DR Tower (14th floor), 65/2/2, Purana Paltan, Dhaka-1000");
            headOffice.setPhone("02478853405");
            headOffice.setMobile("01763001787");
            headOffice.setFax("+88 02 55112742");
            headOffice.setEmail("info@ciclbd.com");
            headOffice.setWebsite("www.islamiinsurance.com");
            
            IssueOffice chittagong = new IssueOffice();
            chittagong.setName("Chittagong Branch");
            chittagong.setAddress("Agrabad C/A, Chittagong");
            chittagong.setPhone("031-123456");
            chittagong.setMobile("01812345678");
            chittagong.setFax("+88 031 654321");
            chittagong.setEmail("ctg@ciclbd.com");
            chittagong.setWebsite("www.islamiinsurance.com");

            issueOfficeRepository.save(headOffice);
            issueOfficeRepository.save(chittagong);
        }
    }
}
