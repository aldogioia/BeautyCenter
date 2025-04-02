package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.BookingDto;
import org.aldo.beautycenter.data.dto.CreateBookingDto;
import org.aldo.beautycenter.data.entities.Booking;

import java.time.LocalDate;
import java.util.List;

public interface BookingService {
    List<BookingDto> getCustomerBookingsInDate(String customerId, LocalDate date);
    List<BookingDto> getOperatorBookingsInDate(String userId, LocalDate date);
    List<Booking> getBookingsByDate(LocalDate date);
    BookingDto addBooking(CreateBookingDto createBookingDto);
    void deleteBooking(String bookingId);
}
