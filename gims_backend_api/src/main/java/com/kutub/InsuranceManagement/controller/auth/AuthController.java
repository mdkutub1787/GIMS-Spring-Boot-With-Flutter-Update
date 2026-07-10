package com.kutub.InsuranceManagement.controller.auth;


import com.kutub.InsuranceManagement.dto.common.GenericResponse;
import com.kutub.InsuranceManagement.dto.auth.LoginRequest;
import com.kutub.InsuranceManagement.dto.auth.RegisterRequest;
import com.kutub.InsuranceManagement.entity.auth.AuthenticationResponse;
import com.kutub.InsuranceManagement.service.auth.AuthService;
import lombok.AllArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@AllArgsConstructor
@CrossOrigin(origins = "*")
public class AuthController {

    private static final Logger log = LoggerFactory.getLogger(AuthController.class);

    private final AuthService authService;

    @PostMapping(value = "/register", consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<AuthenticationResponse> register(@RequestBody RegisterRequest request) {
        log.debug("Register request received for username: {}", request.getUsername());
        AuthenticationResponse response = authService.register(request);
        log.debug("Register response for username {}: {}", request.getUsername(), response.getMessage());
        return ResponseEntity.ok(response);
    }

    @PostMapping(value = "/login", consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<AuthenticationResponse> login(@RequestBody LoginRequest request) {
        log.debug("Login request received for username: {}", request.getUsername());
        AuthenticationResponse response = authService.authenticate(request);
        log.debug("Login response for username {}: {}", request.getUsername(), response.getMessage());
        return ResponseEntity.ok(response);
    }

    @PostMapping("/verify-otp")
    public ResponseEntity<GenericResponse> verifyOtp(@RequestBody Map<String, String> payload) {
        String code = payload.get("code");
        log.debug("OTP verification request received for code: {}", code);
        authService.activateUser(code);
        return ResponseEntity.ok(new GenericResponse(true, "User activated successfully!"));
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<GenericResponse> forgotPassword(@RequestBody Map<String, String> payload) {
        String email = payload.get("email");
        log.debug("Forgot password request received for email: {}", email);
        authService.forgotPassword(email);
        return ResponseEntity.ok(new GenericResponse(true, "Password reset code has been sent to your email."));
    }

    @PostMapping("/verify-reset-code")
    public ResponseEntity<GenericResponse> verifyResetCode(@RequestBody Map<String, String> payload) {
        String code = payload.get("code");
        log.debug("Verify reset code request received for code: {}", code);
        authService.verifyPasswordResetCode(code);
        return ResponseEntity.ok(new GenericResponse(true, "Code verified successfully."));
    }

    @PostMapping("/reset-password")
    public ResponseEntity<GenericResponse> resetPassword(@RequestBody Map<String, String> payload) {
        String code = payload.get("code");
        String newPassword = payload.get("newPassword");
        log.debug("Reset password request received for code: {}", code);
        authService.resetPassword(code, newPassword);
        return ResponseEntity.ok(new GenericResponse(true, "Password has been reset successfully."));
    }
}
