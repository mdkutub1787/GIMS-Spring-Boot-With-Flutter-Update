package com.kutub.InsuranceManagement.repository.location;

import com.kutub.InsuranceManagement.entity.location.Thana;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ThanaRepository extends JpaRepository<Thana, Long> {
    List<Thana> findByDistrictId(Long districtId);
    List<Thana> findByCityCorporationId(Long cityCorporationId);
}
