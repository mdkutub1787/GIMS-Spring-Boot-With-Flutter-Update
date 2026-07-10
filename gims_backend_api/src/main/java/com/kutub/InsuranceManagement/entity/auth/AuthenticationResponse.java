package com.kutub.InsuranceManagement.entity.auth;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.kutub.InsuranceManagement.dto.auth.UserDto;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class AuthenticationResponse {

    private String token;
    private String message;
    private UserDto user;

    public AuthenticationResponse(String token, String message) {
        this.token = token;
        this.message = message;
    }
}
