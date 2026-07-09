package com.kutub.InsuranceManagement.repository.location;

import com.kutub.InsuranceManagement.entity.location.Ward;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface WardRepository extends JpaRepository<Ward, Long> {
    List<Ward> findByPourashavaId(Long pourashavaId);
    List<Ward> findByThanaId(Long thanaId);
}
