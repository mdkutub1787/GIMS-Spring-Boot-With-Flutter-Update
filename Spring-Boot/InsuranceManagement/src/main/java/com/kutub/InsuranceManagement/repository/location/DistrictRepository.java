package com.kutub.InsuranceManagement.repository.location;

import com.kutub.InsuranceManagement.entity.location.District;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DistrictRepository extends JpaRepository<District, Long> {
    List<District> findByDivisionId(Long divisionId);
}
