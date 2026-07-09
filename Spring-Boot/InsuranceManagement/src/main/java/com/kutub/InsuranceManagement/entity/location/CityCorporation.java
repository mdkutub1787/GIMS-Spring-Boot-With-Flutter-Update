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
public class CityCorporation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "district_id")
    @JsonIgnore
    private District district;

    // A City Corporation can have multiple Thanas
    @OneToMany(mappedBy = "cityCorporation", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Thana> thanas;
}
