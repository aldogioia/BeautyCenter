package org.aldo.beautycenter.data.dao;

import org.aldo.beautycenter.data.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserDao extends JpaRepository<User, String> {
    Optional<User> findByEmail(String email);
}
