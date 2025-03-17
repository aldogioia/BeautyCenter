package org.aldo.beautycenter.data.dao;

import org.aldo.beautycenter.data.entities.Service;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ServiceDao extends JpaRepository<Service, String> {
}
