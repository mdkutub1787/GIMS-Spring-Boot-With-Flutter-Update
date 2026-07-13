package com.kutub.InsuranceManagement.entity.utility;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;
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
@Table(name = "bnk_info")
public class BnkInfo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "bnkKeyCode")
    @JsonProperty("bankId")
    @JsonAlias("id")
    private Integer bnkKeyCode;

    @Column(name = "bank")
    private String bank;

    @Column(name = "bic_no")
    private String bicNo;

    @Column(name = "bankCode")
    private String bankCode;

    @Column(name = "bbFICodeRemit")
    private String bbFICodeRemit;

    @Column(name = "country")
    private String country;

    @Column(name = "usr")
    private String usr;

    @Column(name = "dt")
    private java.sql.Date dt;

    @Column(name = "tm")
    private java.sql.Time tm;

    @Column(name = "npsb")
    private Integer npsb;

    @JsonIgnore
    @OneToMany(mappedBy = "bnkInfo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<BnkBrInfo> branches;
}
