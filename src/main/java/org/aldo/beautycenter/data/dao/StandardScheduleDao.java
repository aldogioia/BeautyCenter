package org.aldo.beautycenter.data.dao;

import org.aldo.beautycenter.data.entities.StandardSchedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.DayOfWeek;
import java.util.List;
import java.util.Optional;

@Repository
public interface StandardScheduleDao extends JpaRepository<StandardSchedule, String> {
    List<StandardSchedule> findAllByOperatorId(String operatorId);
    Optional<StandardSchedule> findByOperatorIdAndDay(String operatorId, DayOfWeek day);
    boolean existsByDay(DayOfWeek day);
}
