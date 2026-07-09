package com.kutub.InsuranceManagement.repository.location;

import com.kutub.InsuranceManagement.entity.location.UnionArea;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UnionAreaRepository extends JpaRepository<UnionArea, Long> {
    List<UnionArea> findByThanaId(Long thanaId);
}
