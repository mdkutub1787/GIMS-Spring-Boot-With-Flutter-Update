package com.kutub.InsuranceManagement.entity.fire;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.kutub.InsuranceManagement.entity.utility.BnkInfo;
import com.kutub.InsuranceManagement.entity.utility.BnkBrInfo;
import com.kutub.InsuranceManagement.entity.utility.InsInfo;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "fire_policy")
public class FirePolicy {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonProperty("policyId")
    @JsonAlias("id")
    private int id;

    @Column(name = "sys_number", unique = true, nullable = true)
    private String sysNumber;

    @ManyToOne
    @JoinColumn(name = "company_id", nullable = false)
    private InsInfo company;

    @Column(nullable = false)
    @Temporal(TemporalType.DATE)
    private Date date = new Date();

    @ManyToOne
    @JoinColumn(name = "bank_id", nullable = false)
    private BnkInfo bank;

    @ManyToOne
    @JoinColumn(name = "branch_id", nullable = true)
    private BnkBrInfo branch;

    @Column(nullable = false)
    private String policyholder;

    @Column(nullable = false)
    private String address;

    @Column(nullable = false)
    private String stockInsured;

    @Column(nullable = false)
    private double sumInsured;

    @Column(nullable = false)
    private String interestInsured;

    @Column(nullable = false)
    private String coverage;

    @Column(nullable = false)
    private String location;

    @Column(nullable = false)
    private String construction;

    @Column(nullable = false)
    private String owner;

    @Column(nullable = false)
    private String usedAs;

    @Column(nullable = false)
    @Temporal(TemporalType.DATE)
    private Date periodFrom;

    @Column(nullable = false)
    @Temporal(TemporalType.DATE)
    private Date periodTo;

    @JsonIgnore
    @OneToMany(mappedBy = "policy", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<FireBill> bills;

    // Custom setter for periodFrom
    public void setPeriodFrom(Date periodFrom) {
        this.periodFrom = periodFrom;
        setPeriodToAutomatically();
    }

    // Automatically sets periodTo to one year after periodFrom
    private void setPeriodToAutomatically() {
        if (this.periodFrom != null) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(this.periodFrom);
            calendar.add(Calendar.YEAR, 1);
            this.periodTo = calendar.getTime();
        }
    }
}
