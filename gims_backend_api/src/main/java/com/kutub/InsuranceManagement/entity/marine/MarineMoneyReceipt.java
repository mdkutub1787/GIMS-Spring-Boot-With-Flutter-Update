package com.kutub.InsuranceManagement.entity.marine;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "marine_money_receipt")
public class MarineMoneyReceipt {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "issueOfficeId")
    private com.kutub.InsuranceManagement.entity.utility.IssueOffice issuingOffice;

    private String classOfInsurance;

    @Temporal(TemporalType.DATE)
    private Date date = new Date();

    private String modeOfPayment;

    private String issuedAgainst;

    @ManyToOne(fetch = FetchType.EAGER, cascade = { CascadeType.PERSIST, CascadeType.MERGE })
    @JoinColumn(name = "marinebillId")
    private MarineBill marinebill;

}
