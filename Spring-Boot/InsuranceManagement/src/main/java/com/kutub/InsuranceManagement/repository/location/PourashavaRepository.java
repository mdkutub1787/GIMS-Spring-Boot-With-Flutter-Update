package com.kutub.InsuranceManagement.repository.location;

import com.kutub.InsuranceManagement.entity.location.Pourashava;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PourashavaRepository extends JpaRepository<Pourashava, Long> {
    List<Pourashava> findByThanaId(Long thanaId);
}
