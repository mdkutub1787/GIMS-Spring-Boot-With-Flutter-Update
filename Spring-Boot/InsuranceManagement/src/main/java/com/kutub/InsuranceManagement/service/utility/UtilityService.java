package com.kutub.InsuranceManagement.service.utility;

import com.kutub.InsuranceManagement.entity.utility.Bank;
import com.kutub.InsuranceManagement.entity.utility.Branch;
import com.kutub.InsuranceManagement.entity.utility.InsuranceCompany;
import com.kutub.InsuranceManagement.repository.utility.BankRepository;
import com.kutub.InsuranceManagement.repository.utility.BranchRepository;
import com.kutub.InsuranceManagement.repository.utility.InsuranceCompanyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UtilityService {

    @Autowired
    private BankRepository bankRepository;

    @Autowired
    private BranchRepository branchRepository;

    @Autowired
    private InsuranceCompanyRepository insuranceCompanyRepository;

    public List<Bank> getAllBanks() {
        return bankRepository.findAll();
    }

    public List<Branch> getBranchesByBankId(Long bankId) {
        return branchRepository.findByBankId(bankId);
    }

    public List<InsuranceCompany> getAllInsuranceCompanies() {
        return insuranceCompanyRepository.findAll();
    }

    public List<InsuranceCompany> getInsuranceCompaniesByType(String type) {
        return insuranceCompanyRepository.findByType(type);
    }
}
