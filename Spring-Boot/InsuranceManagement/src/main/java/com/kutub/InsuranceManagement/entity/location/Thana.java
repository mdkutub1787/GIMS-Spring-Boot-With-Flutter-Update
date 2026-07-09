package com.kutub.InsuranceManagement.entity.location;

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
public class Thana {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "district_id", nullable = true)
    @JsonIgnore
    private District district;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "city_corporation_id", nullable = true)
    @JsonIgnore
    private CityCorporation cityCorporation;

    @OneToMany(mappedBy = "thana", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Pourashava> pourashavas;

    @OneToMany(mappedBy = "thana", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<UnionArea> unions;
    
    @OneToMany(mappedBy = "thana", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Ward> wards;
}
