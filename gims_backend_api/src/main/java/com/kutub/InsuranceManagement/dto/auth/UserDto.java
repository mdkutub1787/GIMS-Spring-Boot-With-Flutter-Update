package com.kutub.InsuranceManagement.dto.auth;

import lombok.Data;

@Data
public class UserDto {
    private long id;

    private String username;
    private String email;
    private String phone;
    private String role;
    
    private Integer companyId;
    private String companyName;
    private Integer officeId;
    private String officeName;
}
