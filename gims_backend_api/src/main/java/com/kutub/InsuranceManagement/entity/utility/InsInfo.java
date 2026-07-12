package com.kutub.InsuranceManagement.entity.utility;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "insurance_companies")
public class InsInfo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonProperty("companyId")
    @JsonAlias("id")
    private Integer id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String type; // Life, Non-Life

    @Column(nullable = false)
    private String sector; // Private, Public

    public InsInfo(String name, String type, String sector) {
        this.name = name;
        this.type = type;
        this.sector = sector;
    }
}
