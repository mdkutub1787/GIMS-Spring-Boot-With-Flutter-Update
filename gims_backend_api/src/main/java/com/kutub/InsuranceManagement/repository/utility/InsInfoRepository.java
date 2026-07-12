package com.kutub.InsuranceManagement.repository.utility;

import com.kutub.InsuranceManagement.entity.utility.InsInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface InsInfoRepository extends JpaRepository<InsInfo, Integer> {
    List<InsInfo> findByType(String type);
}
