package org.aldo.beautycenter.data.dao;

import org.aldo.beautycenter.data.entities.Blacklist;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Date;

@Repository
public interface BlacklistDao extends JpaRepository<Blacklist, String> {
    boolean existsByToken(String token);
    void deleteAllByExpirationBefore(Date expiration);
}
