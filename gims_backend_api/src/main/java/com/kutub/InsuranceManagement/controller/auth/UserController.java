package com.kutub.InsuranceManagement.controller.auth;

import com.kutub.InsuranceManagement.dto.auth.ProfileUpdateRequest;
import com.kutub.InsuranceManagement.dto.common.GenericResponse;
import com.kutub.InsuranceManagement.entity.auth.User;
import com.kutub.InsuranceManagement.service.auth.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class UserController {

    private final UserService userService;

    @GetMapping("/me")
    public ResponseEntity<User> getProfile() {
        return ResponseEntity.ok(userService.getProfile());
    }

    @PutMapping("/update")
    public ResponseEntity<GenericResponse> updateProfile(@RequestBody ProfileUpdateRequest request) {
        userService.updateProfile(request);
        return ResponseEntity.ok(new GenericResponse(true, "Profile updated successfully"));
    }
}
