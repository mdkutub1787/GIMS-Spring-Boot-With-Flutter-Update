package com.kutub.InsuranceManagement.repository.utility;

import com.kutub.InsuranceManagement.entity.utility.Branch;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BranchRepository extends JpaRepository<Branch, Long> {
    List<Branch> findByBankId(Long bankId);
}
