package com.kutub.InsuranceManagement.repository;

import com.kutub.InsuranceManagement.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User,Long> {

    Optional<User> findByEmail(String email);
    Optional<User> findByUsername(String username);
    Optional<User> findByActivationCode(String code);
    Optional<User> findByResetPasswordCode(String code);
}
