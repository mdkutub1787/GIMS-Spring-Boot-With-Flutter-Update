package com.kutub.InsuranceManagement.repository.marine;

import com.kutub.InsuranceManagement.entity.marine.MarineBill;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MarineBillRepository extends JpaRepository<MarineBill, Long> {

    // Custom query to find bills by policy ID
    @Query("SELECT b FROM MarineBill b WHERE b.marineDetails.id = :marineDetailsId")
    List<MarineBill> findMarineBillsByMarinePolicyId(@Param("marineDetailsId") long marineDetailsId);
}
