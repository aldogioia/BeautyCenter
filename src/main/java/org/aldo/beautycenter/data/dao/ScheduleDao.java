package org.aldo.beautycenter.data.dao;

import org.aldo.beautycenter.data.entities.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ScheduleDao extends JpaRepository<Schedule, String> {
}
