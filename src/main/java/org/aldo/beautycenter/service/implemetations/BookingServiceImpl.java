package org.aldo.beautycenter.service.implemetations;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.BookingDao;
import org.aldo.beautycenter.data.dto.BookingDto;
import org.aldo.beautycenter.data.dto.CreateBookingDto;
import org.aldo.beautycenter.data.entities.Booking;
import org.aldo.beautycenter.data.entities.Room;
import org.aldo.beautycenter.security.exception.customException.BookingConflictException;
import org.aldo.beautycenter.service.interfaces.BookingService;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class BookingServiceImpl implements BookingService {
    private final BookingDao bookingDao;
    private final ModelMapper modelMapper;

    @Override
    public List<BookingDto> getCustomerBookingsInDate(String customerId, LocalDate date) {
        return bookingDao.findAllByCustomer_IdAndDateIsBefore(customerId, date)
                .stream()
                .map(booking -> modelMapper.map(booking, BookingDto.class))
                .toList();
    }
    @Override
    public List<BookingDto> getOperatorBookingsInDate(String userId, LocalDate date) {
        return bookingDao.findAllByDateAndOperator_Id(date, userId)
                .stream()
                .map(booking -> modelMapper.map(booking, BookingDto.class))
                .toList();
    }
    @Override
    public List<Booking> getBookingsByDate(LocalDate date) {
        return bookingDao.findAllByDate(date);
    }
    @Override
    @Transactional
    public BookingDto addBooking(CreateBookingDto createBookingDto) {
        Boolean isOperatorBusy = bookingDao
                .existsByDateAndTimeAndOperator_Id(
                        createBookingDto.getDate(),
                        createBookingDto.getTime(),
                        createBookingDto.getOperator());

        Optional<Room> room = bookingDao
                .findRoomAvailable(
                        createBookingDto.getDate(),
                        createBookingDto.getTime(),
                        createBookingDto.getService());

        if (isOperatorBusy || room.isEmpty())
            throw new BookingConflictException("L'operatore o la stanza non sono disponibili per questa data e ora");

        Booking booking = modelMapper.map(createBookingDto, Booking.class);
        booking.setRoom(room.get());
        bookingDao.save(booking);
        return modelMapper.map(booking, BookingDto.class);
    }
    @Override
    public void deleteBooking(String bookingId) {
        bookingDao.deleteById(bookingId);
    }
}
