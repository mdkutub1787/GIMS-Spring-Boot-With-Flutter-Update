package com.kutub.InsuranceManagement.security;

import com.kutub.InsuranceManagement.security.jwt.JwtAuthenticationFilter;
import com.kutub.InsuranceManagement.service.auth.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final UserService userService;
    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
                .csrf(AbstractHttpConfigurer::disable)
                .cors(Customizer.withDefaults())
                .authorizeHttpRequests(req ->
                        req.requestMatchers(
                                        // Public API endpoints
                                        "/api/auth/**",
                                        "/api/banks/**",
                                        "/api/location/**",
                                        "/images/**"
                                ).permitAll()
                                // Policies: GET is public, others require ADMIN role
                                .requestMatchers(HttpMethod.GET, "/api/policy/**").permitAll()
                                .requestMatchers(HttpMethod.POST, "/api/policy/save").hasAuthority("ADMIN")
                                .requestMatchers(HttpMethod.PUT, "/api/policy/update/**").hasAuthority("ADMIN")
                                .requestMatchers(HttpMethod.DELETE, "/api/policy/delete/**").hasAuthority("ADMIN")
                                // Bills: Some are for ADMIN, others for USER/ADMIN
                                .requestMatchers("/api/bill/save").hasAuthority("ADMIN")
                                .requestMatchers("/api/bill/{id}", "/api/bill/all/**", "/api/bill/").hasAnyAuthority("ADMIN", "USER")
                                // Any other request must be authenticated
                                .anyRequest().authenticated()
                )
                .userDetailsService(userService)
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    @Bean
    public PasswordEncoder encoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {
        return configuration.getAuthenticationManager();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOriginPatterns(List.of("*"));
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("*"));
        configuration.setAllowCredentials(true);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
