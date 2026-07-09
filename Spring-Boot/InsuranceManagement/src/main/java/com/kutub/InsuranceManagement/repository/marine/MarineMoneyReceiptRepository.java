package com.kutub.InsuranceManagement.repository.marine;

import com.kutub.InsuranceManagement.entity.marine.MarineMoneyReceipt;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MarineMoneyReceiptRepository extends JpaRepository<MarineMoneyReceipt, Long> {
}
