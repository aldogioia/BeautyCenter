package org.aldo.beautycenter.data.dao;

import org.aldo.beautycenter.data.entities.FcmToken;
import org.aldo.beautycenter.data.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FcmTokenDao extends JpaRepository<FcmToken, String> {
    List<FcmToken> findAllByUser(User user);
    Optional<FcmToken> findByToken(String token);
    void deleteByToken(String token);
}
