package com.kutub.InsuranceManagement.service.auth;

import com.kutub.InsuranceManagement.dto.auth.LoginRequest;
import com.kutub.InsuranceManagement.dto.auth.RegisterRequest;
import com.kutub.InsuranceManagement.dto.auth.UserDto;
import com.kutub.InsuranceManagement.entity.auth.AuthenticationResponse;
import com.kutub.InsuranceManagement.entity.auth.Role;
import com.kutub.InsuranceManagement.entity.auth.Token;
import com.kutub.InsuranceManagement.entity.auth.User;
import com.kutub.InsuranceManagement.exception.auth.UserAlreadyExistsException;
import com.kutub.InsuranceManagement.repository.auth.TokenRepository;
import com.kutub.InsuranceManagement.repository.auth.UserRepository;
import com.kutub.InsuranceManagement.security.jwt.JwtService;
import jakarta.mail.MessagingException;
import lombok.AllArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.io.UnsupportedEncodingException;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.List;

@Service
@AllArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final TokenRepository tokenRepository;
    private final AuthenticationManager authenticationManager;
    private final EmailService emailService;

    private String generateOtpCode() {
        SecureRandom random = new SecureRandom();
        int code = 100000 + random.nextInt(900000); // 6-digit code
        return String.valueOf(code);
    }

    private AuthenticationResponse registerUser(RegisterRequest request, Role role) {
        if (userRepository.findByUsername(request.getUsername()).isPresent()) {
            throw new UserAlreadyExistsException("User with username " + request.getUsername() + " already exists");
        }
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new UserAlreadyExistsException("User with email " + request.getEmail() + " already exists");
        }

        User user = new User();
        user.setFirstname(request.getFirstname());
        user.setLastname(request.getLastname());
        user.setUsername(request.getUsername());
        user.setEmail(request.getEmail());
        user.setPhone(request.getPhone());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRole(role);
        
        String activationCode = generateOtpCode();
        user.setActivationCode(activationCode);
        user.setCodeExpiresAt(LocalDateTime.now().plusMinutes(10));

        userRepository.save(user);
        sendEmail(user.getEmail(), user.getFirstname(), activationCode, "Your Account Activation Code", "Your activation code is: ");

        return new AuthenticationResponse(null, "User registration was successful. Please check your email for the activation code.");
    }

    public AuthenticationResponse register(RegisterRequest request) {
        return registerUser(request, Role.USER);
    }

    public AuthenticationResponse authenticate(LoginRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsername(),
                        request.getPassword()
                )
        );

        User user = userRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new UsernameNotFoundException("User not found with username: " + request.getUsername()));

        String jwt = jwtService.generateToken(user);
        revokeAllTokenByUser(user);
        saveUserToken(jwt, user);

        UserDto userDto = new UserDto();
        userDto.setId(user.getId());
        userDto.setFirstname(user.getFirstname());
        userDto.setLastname(user.getLastname());
        userDto.setUsername(user.getUsername());
        userDto.setEmail(user.getEmail());
        userDto.setPhone(user.getPhone());
        userDto.setRole(user.getRole().name());

        return new AuthenticationResponse(jwt, "User login was successful", userDto);
    }

    public String activateUser(String code) {
        User user = userRepository.findByActivationCode(code)
                .orElseThrow(() -> new RuntimeException("Invalid activation code"));

        if (user.getCodeExpiresAt().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("Activation code has expired");
        }

        user.setActive(true);
        user.setActivationCode(null);
        user.setCodeExpiresAt(null);
        userRepository.save(user);

        return "User activated successfully!";
    }

    public void forgotPassword(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));

        String resetCode = generateOtpCode();
        user.setResetPasswordCode(resetCode);
        user.setResetCodeExpiresAt(LocalDateTime.now().plusMinutes(10));
        userRepository.save(user);

        sendEmail(email, user.getFirstname(), resetCode, "Password Reset Code", "Your password reset code is: ");
    }

    public String verifyPasswordResetCode(String code) {
        User user = userRepository.findByResetPasswordCode(code)
                .orElseThrow(() -> new RuntimeException("Invalid password reset code"));

        if (user.getResetCodeExpiresAt().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("Password reset code has expired");
        }
        return "Code verified successfully.";
    }


    public void resetPassword(String code, String newPassword) {
        User user = userRepository.findByResetPasswordCode(code)
                .orElseThrow(() -> new RuntimeException("Invalid password reset code"));

        if (user.getResetCodeExpiresAt().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("Password reset code has expired");
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        user.setResetPasswordCode(null);
        user.setResetCodeExpiresAt(null);
        userRepository.save(user);
    }

    private void sendEmail(String email, String firstname, String code, String subject, String title) {
        String htmlContent = """
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>%s</title>
                <style>
                    body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; }
                    .container { max-width: 600px; margin: 20px auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
                    .header { background-color: #4a90e2; color: #ffffff; padding: 20px; text-align: center; }
                    .header h1 { margin: 0; }
                    .content { padding: 30px; text-align: center; }
                    .content p { color: #555555; line-height: 1.6; }
                    .otp-box { background-color: #eef4ff; border: 2px dashed #4a90e2; color: #333333; font-size: 36px; font-weight: bold; padding: 15px 20px; margin: 20px auto; display: inline-block; border-radius: 8px; letter-spacing: 5px; }
                    .expiry { font-size: 14px; color: #888888; }
                    .footer { background-color: #f4f4f4; color: #888888; padding: 15px; text-align: center; font-size: 12px; }
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="header">
                        <h1>%s</h1>
                    </div>
                    <div class="content">
                        <p>Hi %s,</p>
                        <p>Thank you for using our service. Please use the code below to proceed.</p>
                        <div class="otp-box">%s</div>
                        <p class="expiry">This code will expire in 10 minutes.</p>
                    </div>
                    <div class="footer">
                        <p>&copy; 2024 Insurance Management. All rights reserved.</p>
                    </div>
                </div>
            </body>
            </html>
            """.formatted(subject, title, firstname, code);

        try {
            emailService.sendSimpleEmail(email, subject, htmlContent);
        } catch (MessagingException | UnsupportedEncodingException e) {
            throw new RuntimeException("Failed to send email", e);
        }
    }

    private void saveUserToken(String jwt, User user) {
        Token token = new Token();
        token.setToken(jwt);
        token.setLoggedOut(false);
        token.setUser(user);
        tokenRepository.save(token);
    }

    public void revokeAllTokenByUser(User user) {
        List<Token> validTokens = tokenRepository.findAllTokensByUser(user.getId());
        if (validTokens.isEmpty()) {
            return;
        }
        validTokens.forEach(t -> t.setLoggedOut(true));
        tokenRepository.saveAll(validTokens);
    }
}
