package com.kutub.InsuranceManagement.service.utility;

import com.kutub.InsuranceManagement.entity.utility.BnkInfo;
import com.kutub.InsuranceManagement.entity.utility.BnkBrInfo;
import com.kutub.InsuranceManagement.entity.utility.InsInfo;
import com.kutub.InsuranceManagement.repository.utility.BnkInfoRepository;
import com.kutub.InsuranceManagement.repository.utility.BnkBrInfoRepository;
import com.kutub.InsuranceManagement.repository.utility.InsInfoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UtilityService {

    @Autowired
    private BnkInfoRepository bnkInfoRepository;

    @Autowired
    private BnkBrInfoRepository bnkBrInfoRepository;

    @Autowired
    private InsInfoRepository insInfoRepository;

    public List<BnkInfo> getAllBanks() {
        return bnkInfoRepository.findAll();
    }

    public List<BnkBrInfo> getBranchesByBankId(Integer bankId) {
        return bnkBrInfoRepository.findByBnkInfo_bnkKeyCode(bankId);
    }

    public List<InsInfo> getAllInsuranceCompanies() {
        return insInfoRepository.findAll();
    }

    public List<InsInfo> getInsuranceCompaniesByType(String type) {
        return insInfoRepository.findByType(type);
    }
}
