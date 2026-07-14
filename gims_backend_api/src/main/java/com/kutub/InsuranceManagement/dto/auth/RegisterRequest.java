package com.kutub.InsuranceManagement.dto.auth;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RegisterRequest {

    private String username;
    private String email;
    private String phone;
    private String password;
    private Integer companyId;
    
    // Issue Office Details
    private String officeName;
    private String officeAddress;
    private String officePhone;
    private String officeMobile;
    private String officeFax;
    private String officeEmail;
    private String officeWebsite;
}
