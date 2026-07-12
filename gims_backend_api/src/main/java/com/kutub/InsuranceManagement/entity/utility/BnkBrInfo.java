package com.kutub.InsuranceManagement.entity.utility;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "bnk_br_info")
public class BnkBrInfo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "brKeyCode")
    @JsonProperty("branchId")
    @JsonAlias("id")
    private Integer brKeyCode;

    @Column(name = "branchName")
    private String branchName;

    @Column(name = "branchCode")
    private String branchCode;

    @Column(name = "adBrCode")
    private String adBrCode;

    @Column(name = "routingNumber")
    private String routingNumber;

    @Column(name = "usr")
    private String usr;

    @Column(name = "dt")
    private java.sql.Date dt;

    @Column(name = "tm")
    private java.sql.Time tm;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "bankCode", referencedColumnName = "bnkKeyCode")
    @JsonIgnore
    private BnkInfo bnkInfo;
}
