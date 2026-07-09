package com.kutub.InsuranceManagement.entity.location;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Ward {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pourashava_id", nullable = true)
    @JsonIgnore
    private Pourashava pourashava;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "thana_id", nullable = true)
    @JsonIgnore
    private Thana thana;
}
