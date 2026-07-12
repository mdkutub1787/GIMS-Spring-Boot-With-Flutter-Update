package com.kutub.InsuranceManagement.repository.utility;

import com.kutub.InsuranceManagement.entity.utility.BnkBrInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BnkBrInfoRepository extends JpaRepository<BnkBrInfo, Integer> {
    List<BnkBrInfo> findByBnkInfo_bnkKeyCode(Integer bankCode);
}
