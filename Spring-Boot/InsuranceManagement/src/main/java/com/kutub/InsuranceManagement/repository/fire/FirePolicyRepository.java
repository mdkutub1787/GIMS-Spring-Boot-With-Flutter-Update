package com.kutub.InsuranceManagement.repository.fire;

import com.kutub.InsuranceManagement.entity.fire.FirePolicy;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FirePolicyRepository extends JpaRepository<FirePolicy, Integer> {


    // Search Policy records by policyholder name (full or partial, case-insensitive)
    @Query("SELECT p FROM FirePolicy p WHERE LOWER(p.policyholder) LIKE LOWER(CONCAT('%', :policyholder, '%'))")
    List<FirePolicy> findByPolicyHolder(@Param("policyholder") String policyholder);

    // Search Policy records by bank name (full or partial, case-insensitive)
    @Query("SELECT p FROM FirePolicy p WHERE LOWER(p.bankName) LIKE LOWER(CONCAT('%', :bankName, '%'))")
    List<FirePolicy> findByBankName(@Param("bankName") String bankName);


}
