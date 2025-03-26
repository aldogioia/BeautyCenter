package org.aldo.beautycenter.data.dao;

import org.aldo.beautycenter.data.entities.PasswordToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PasswordTokenDao extends JpaRepository<PasswordToken, String> {
    PasswordToken findByToken(String token);
}
