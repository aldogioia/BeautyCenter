package org.aldo.beautycenter.data.dao;

import org.aldo.beautycenter.data.entities.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CustomerDao extends JpaRepository<Customer, String> {
    Optional<Customer> findByEmail(String email);
}
