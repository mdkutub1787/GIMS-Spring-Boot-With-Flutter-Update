package com.kutub.InsuranceManagement.repository.utility;

import com.kutub.InsuranceManagement.entity.utility.InsuranceCompany;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface InsuranceCompanyRepository extends JpaRepository<InsuranceCompany, Long> {
    List<InsuranceCompany> findByType(String type);
    List<InsuranceCompany> findBySector(String sector);
}
