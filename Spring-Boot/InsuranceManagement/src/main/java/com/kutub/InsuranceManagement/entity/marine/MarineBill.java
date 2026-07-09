package com.kutub.InsuranceManagement.entity.marine;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "marineinsurancebills")
public class MarineBill {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column( name = "marine_rate_% ",nullable = false)
    private double marineRate;

    @Column( name = "warSrcc_rate_% ",nullable = false)
    private double warSrccRate;

    @Column(nullable = false)
    private double netPremium;

    @Column( name = "tax_rate_% ",nullable = false)
    private double tax = 15; // Fixed tax rate at 15%

    @Column(nullable = false)
    private double stampDuty;

    @Column(nullable = false)
    private double grossPremium;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "marineDetailsId", nullable = false)
    private MarinePolicy marineDetails;

    @JsonIgnore
    @OneToMany(mappedBy = "marinebill",  cascade = CascadeType.ALL)
    private List<MarineMoneyReceipt> marinebillreceipts;

}
