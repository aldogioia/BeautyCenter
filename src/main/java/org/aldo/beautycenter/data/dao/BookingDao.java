package org.aldo.beautycenter.data.dao;

import org.aldo.beautycenter.data.entities.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Service;

@Service
public interface BookingDao extends JpaRepository<Booking, String> {
}
