package com.kutub.InsuranceManagement.entity.fire;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "fire_money_receipt")
public class FireMoneyReceipt {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "issueOfficeId")
    private com.kutub.InsuranceManagement.entity.utility.IssueOffice issuingOffice;

    private String classOfInsurance;

    @Column(nullable = false)
    @Temporal(TemporalType.DATE)
    private Date date = new Date(); 

    private String modeOfPayment;
  
    private String issuedAgainst;

    @ManyToOne(fetch = FetchType.EAGER, cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinColumn(name = "billId")
    private FireBill bill;

}
