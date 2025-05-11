package org.aldo.beautycenter.data.dao;

import org.aldo.beautycenter.data.entities.PasswordToken;
import org.aldo.beautycenter.data.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PasswordTokenDao extends JpaRepository<PasswordToken, String> {
    Optional<PasswordToken> findByToken(String token);

    Optional<PasswordToken> findByUser(User user);
}
