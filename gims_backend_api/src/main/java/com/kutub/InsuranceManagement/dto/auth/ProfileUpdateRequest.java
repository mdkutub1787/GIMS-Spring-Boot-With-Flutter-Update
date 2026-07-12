package com.kutub.InsuranceManagement.dto.auth;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProfileUpdateRequest {
    private String firstname;
    private String lastname;
    private String phone;
    private String address;
    private Date dob;
    private String gender;
}
