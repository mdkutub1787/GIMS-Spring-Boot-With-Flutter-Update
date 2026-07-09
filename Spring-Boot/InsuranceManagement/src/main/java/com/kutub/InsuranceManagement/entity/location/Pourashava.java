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
public class Pourashava {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "thana_id")
    @JsonIgnore
    private Thana thana;

    @OneToMany(mappedBy = "pourashava", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Ward> wards;
}
