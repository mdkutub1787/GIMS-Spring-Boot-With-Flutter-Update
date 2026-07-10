package com.kutub.InsuranceManagement.entity.utility;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "insurance_companies")
public class InsuranceCompany {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String type; // Life, Non-Life

    @Column(nullable = false)
    private String sector; // Private, Public

    public InsuranceCompany(String name, String type, String sector) {
        this.name = name;
        this.type = type;
        this.sector = sector;
    }
}
