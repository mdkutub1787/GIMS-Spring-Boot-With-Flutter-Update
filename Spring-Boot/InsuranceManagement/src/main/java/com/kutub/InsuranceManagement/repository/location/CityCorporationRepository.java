package com.kutub.InsuranceManagement.repository.location;

import com.kutub.InsuranceManagement.entity.location.CityCorporation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CityCorporationRepository extends JpaRepository<CityCorporation, Long> {
    List<CityCorporation> findByDistrictId(Long districtId);
}
