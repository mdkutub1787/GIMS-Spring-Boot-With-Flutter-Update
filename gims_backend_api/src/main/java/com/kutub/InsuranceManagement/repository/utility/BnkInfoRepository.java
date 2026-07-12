package com.kutub.InsuranceManagement.repository.utility;

import com.kutub.InsuranceManagement.entity.utility.BnkInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface BnkInfoRepository extends JpaRepository<BnkInfo, Integer> {
    Optional<BnkInfo> findByBank(String bank);
}
