package org.aldo.beautycenter.service.implemetations;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.BookingDao;
import org.aldo.beautycenter.data.dto.BookingDto;
import org.aldo.beautycenter.data.dto.CreateBookingDto;
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
//    @Transactional  todo
    public void addBooking(CreateBookingDto createBookingDto) {
        //todo check if all resources are available
        bookingDao.save(modelMapper.map(createBookingDto, Booking.class));
    }
    @Override
    public void deleteBooking(String bookingId) {
        bookingDao.deleteById(bookingId);
    }
}
