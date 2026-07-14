package com.kutub.InsuranceManagement.service.auth;

import com.kutub.InsuranceManagement.repository.auth.UserRepository;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.security.core.context.SecurityContextHolder;
import com.kutub.InsuranceManagement.entity.auth.User;
import com.kutub.InsuranceManagement.dto.auth.ProfileUpdateRequest;

import lombok.RequiredArgsConstructor;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UserService implements UserDetailsService {

    private final UserRepository userRepository;


    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return userRepository.findByUsername(username)
                .orElseThrow(()->new UsernameNotFoundException("User Not Found With this username: " + username));
    }

    public User getProfile() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with username: " + username));
    }

    @Transactional
    public User updateProfile(ProfileUpdateRequest request) {
        User user = getProfile();
        if (request.getPhone() != null) user.setPhone(request.getPhone());
        if (request.getAddress() != null) user.setAddress(request.getAddress());
        
        if (request.getOfficeName() != null && user.getOffice() != null) {
            user.getOffice().setName(request.getOfficeName());
            // Since CascadeType.ALL might not be enabled, we might need to rely on the transaction to dirty-check the entity,
            // or we could autowire IssueOfficeRepository if needed. JPA dirty checking will usually update it automatically if it's managed.
        }
        
        return userRepository.save(user);
    }
}
