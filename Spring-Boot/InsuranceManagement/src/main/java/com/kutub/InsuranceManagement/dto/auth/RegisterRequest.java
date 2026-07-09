package com.kutub.InsuranceManagement.dto.auth;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RegisterRequest {
    private String firstname;
    private String lastname;
    private String username;
    private String email;
    private String phone;
    private String password;
}
