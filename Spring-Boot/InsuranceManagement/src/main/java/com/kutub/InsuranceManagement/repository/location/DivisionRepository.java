package com.kutub.InsuranceManagement.repository.location;

import com.kutub.InsuranceManagement.entity.location.Division;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DivisionRepository extends JpaRepository<Division, Long> {
}
