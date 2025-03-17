package org.aldo.beautycenter.service.implemetations;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.BookingDao;
import org.aldo.beautycenter.data.dto.BookingDto;
import org.aldo.beautycenter.data.entities.Booking;
import org.aldo.beautycenter.service.interfaces.BookingService;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class BookingServiceImpl implements BookingService {
    private final BookingDao bookingDao;
    private final ModelMapper modelMapper;

    @Override
    public List<BookingDto> getUserBookings(String userId, LocalDate date) {
        return bookingDao.findAllByUser_IdAndDateIsBefore(userId, date)
                .stream()
                .map(booking -> modelMapper.map(booking, BookingDto.class))
                .toList();
    }
    @Override
    public void addBooking(BookingDto bookingDto) {
        bookingDao.save(modelMapper.map(bookingDto, Booking.class));
    }
    @Override
    public void deleteBooking(String bookingId) {
        bookingDao.deleteById(bookingId);
    }
}
