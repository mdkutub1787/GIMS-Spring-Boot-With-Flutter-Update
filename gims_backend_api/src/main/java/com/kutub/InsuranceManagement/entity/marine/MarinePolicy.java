package com.kutub.InsuranceManagement.entity.marine;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.kutub.InsuranceManagement.entity.utility.Bank;
import jakarta.persistence.*;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "marine_insurance_details")
public class MarinePolicy {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonProperty("policyId")
    @JsonAlias("id")
    private long id;

    @Column(unique = true)
    private String sysNumber;

    @Column(nullable = false)
    @Temporal(TemporalType.DATE)
    private Date date = new Date();

    @ManyToOne
    @JoinColumn(name = "bank_id", nullable = false)
    private Bank bank;

    @Column(nullable = false)
    private String policyholder;

    @Column(nullable = false)
    private String address;

    @Column(nullable = false)
    private String voyageFrom;

    @Column(nullable = false)
    private String voyageTo;

    @Column(nullable = false)
    private String via;

    @Column(nullable = false)
    private String stockItem;

    @Positive(message = "Sum insured in USD must be positive")
    @Column(nullable = false)
    private double sumInsuredUsd;

    @Column(nullable = false)
    private double usdRate;

    @Column(nullable = false)
    private double sumInsured;

    @Column(nullable = false)
    private String coverage;

    @JsonIgnore
    @OneToMany(mappedBy = "marineDetails", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<MarineBill> marineBills;

    public void convertSumInsuredUsd(double exchangeRate) {
        this.sumInsured = this.sumInsuredUsd * exchangeRate;
        this.usdRate = exchangeRate;
    }
}
