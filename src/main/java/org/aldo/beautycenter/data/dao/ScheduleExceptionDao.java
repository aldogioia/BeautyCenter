package org.aldo.beautycenter.data.dao;

import org.aldo.beautycenter.data.entities.ScheduleException;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ScheduleExceptionDao extends JpaRepository<ScheduleException, String> {
    List<ScheduleException> findAllByOperatorId(String operatorId);
    @Query(
        "SELECT s " +
        "FROM ScheduleException s " +
        "WHERE s.operator.id = :operatorId " +
        "AND :date " +
        "BETWEEN s.startDate " +
        "AND s.endDate"
    )
    Optional<ScheduleException> findByOperatorIdAndDate(String operatorId, LocalDate date);

    void deleteAllByEndDateBefore(LocalDate date);
}
