package com.kutub.InsuranceManagement.repository.fire;

import com.kutub.InsuranceManagement.entity.fire.FireBill;
import com.kutub.InsuranceManagement.entity.fire.FirePolicy;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FireBillRepository extends JpaRepository<FireBill, Integer> {

    // Custom query to find bills by policyholder in the associated policy
    @Query("SELECT b FROM FireBill b  WHERE LOWER(b.policy.policyholder) LIKE LOWER(CONCAT('%', :policyholder, '%'))")
    List<FireBill> findBillsByPolicyholder(@Param("policyholder") String policyholder);



    // Custom query to find bills by policy ID
    @Query("SELECT b FROM FireBill b WHERE b.policy.id = :policyId")
    List<FireBill> findBillsByPolicyId(@Param("policyId") int policyId);

}
