package com.kutub.InsuranceManagement.dto.auth;

import lombok.Data;

@Data
public class UserDto {
    private long id;
    private String firstname;
    private String lastname;
    private String username;
    private String email;
    private String phone;
    private String role;
}
