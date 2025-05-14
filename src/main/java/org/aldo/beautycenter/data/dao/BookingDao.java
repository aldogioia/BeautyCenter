package org.aldo.beautycenter.data.dao;

import jakarta.persistence.LockModeType;
import org.aldo.beautycenter.data.entities.Booking;
import org.aldo.beautycenter.data.entities.Room;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface BookingDao extends JpaRepository<Booking, String> {
    List<Booking> findAllByBookedForCustomer_IdAndDateIsAfter(String userId, LocalDate date);
    List<Booking> findAllByDateAndOperator_Id(LocalDate date, String operatorId);
    List<Booking> findAllByRoom_Services_Id(String serviceId);
    @Lock(LockModeType.PESSIMISTIC_READ)
    Boolean existsByDateAndTimeAndOperator_Id(LocalDate date, LocalTime time, String operatorId);
    @Query("""
    SELECT r FROM Room r
    JOIN r.services s
    WHERE s.id = :serviceId
    AND NOT EXISTS (
        SELECT b FROM Booking b
        WHERE b.room = r
        AND b.date = :date
        AND b.time = :time
    )
    ORDER BY r.id ASC LIMIT 1
""")
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    Optional<Room> findRoomAvailable(
            @Param("date") LocalDate date,
            @Param("time") LocalTime time,
            @Param("serviceId") String serviceId
    );

}
