package org.aldo.beautycenter.data.dao;

import org.aldo.beautycenter.data.entities.Admin;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AdminDao extends JpaRepository<Admin, String> {
}
