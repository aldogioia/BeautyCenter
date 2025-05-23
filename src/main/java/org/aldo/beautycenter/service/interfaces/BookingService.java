package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.responses.BookingDto;
import org.aldo.beautycenter.data.dto.create.CreateBookingDto;
import org.aldo.beautycenter.data.entities.User;

import java.time.LocalDate;
import java.util.List;

public interface BookingService {
    List<BookingDto> getCustomerBookings(String customerId);
    List<BookingDto> getOperatorBookingsInDate(String operatorId, LocalDate date);
    BookingDto addBooking(CreateBookingDto createBookingDto);
    void deleteBooking(String bookingId, User user);
}
