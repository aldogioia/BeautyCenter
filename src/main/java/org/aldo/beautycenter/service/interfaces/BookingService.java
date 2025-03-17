package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.BookingDto;

import java.time.LocalDate;
import java.util.List;

public interface BookingService {
    List<BookingDto> getUserBookings(String userId, LocalDate date);
    void addBooking(BookingDto bookingDto);
    void deleteBooking(String bookingId);
}
