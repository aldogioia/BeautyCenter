package org.aldo.beautycenter.data.dao;

import org.aldo.beautycenter.data.entities.Operator;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OperatorDao extends JpaRepository<Operator, String> {
    List<Operator> findAllByServices_Id(String id);
}
