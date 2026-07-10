package com.kutub.InsuranceManagement.repository.fire;

import com.kutub.InsuranceManagement.entity.fire.FireMoneyReceipt;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FireMoneyReceiptRepository extends JpaRepository<FireMoneyReceipt, Integer> {
}
