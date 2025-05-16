package org.aldo.beautycenter.data.dao;

import org.aldo.beautycenter.data.entities.Tool;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ToolDao extends JpaRepository<Tool, String> {
}
