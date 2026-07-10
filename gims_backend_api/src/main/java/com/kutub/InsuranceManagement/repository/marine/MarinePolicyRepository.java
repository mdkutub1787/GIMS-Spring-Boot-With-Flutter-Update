package com.kutub.InsuranceManagement.repository.marine;

import com.kutub.InsuranceManagement.entity.marine.MarinePolicy;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MarinePolicyRepository extends JpaRepository<MarinePolicy, Long> {

}
