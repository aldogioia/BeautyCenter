package org.aldo.beautycenter.service.implemetations;

import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.BookingDao;
import org.aldo.beautycenter.data.dao.CustomerDao;
import org.aldo.beautycenter.data.dao.OperatorDao;
import org.aldo.beautycenter.data.dao.ServiceDao;
import org.aldo.beautycenter.data.dto.create.CreateBookingDto;
import org.aldo.beautycenter.data.dto.responses.BookingDto;
import org.aldo.beautycenter.data.entities.*;
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
    private final OperatorDao operatorDao;
    private final CustomerDao customerDao;
    private final ServiceDao serviceDao;
    private final ModelMapper modelMapper;

    @Override
    public List<BookingDto> getCustomerBookings(String customerId) {
        return bookingDao.findAllByBookedForCustomer_IdAndDateIsAfter(customerId, LocalDate.now().minusDays(1))
                .stream()
                .map(booking -> modelMapper.map(booking, BookingDto.class))
                .toList();
    }

    @Override
    public List<BookingDto> getOperatorBookingsInDate(String operatorId, LocalDate date) {
        return bookingDao.findAllByDateAndOperator_Id(date, operatorId)
                .stream()
                .map(booking -> modelMapper.map(booking, BookingDto.class))
                .toList();
    }

    @Override
    public List<Booking> getBookingsByDate(LocalDate date) { //todo serve?
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

        try {
            Booking booking = modelMapper.map(createBookingDto, Booking.class);

            booking.setOperator(operatorDao.findById(createBookingDto.getOperator())
                    .orElseThrow(() -> new EntityNotFoundException("Operatore non trovato")));
            booking.setService(serviceDao.findById(createBookingDto.getService())
                    .orElseThrow(() -> new EntityNotFoundException("Servizio non trovato")));
            if (createBookingDto.getBookedForCustomer() == null) {
                booking.setBookedForCustomer(null);
            } else {
                Customer customer = customerDao.findById(createBookingDto.getBookedForCustomer())
                        .orElseThrow(() -> new EntityNotFoundException("Cliente non trovato"));
                booking.setBookedForCustomer(customer);
            }
            booking.setRoom(room.get());
            bookingDao.save(booking);

            return modelMapper.map(booking, BookingDto.class);
        }
        catch (Exception e) {
            throw new RuntimeException(e.getMessage());
        }
    }

    @Override
    public void deleteBooking(String bookingId) {
        bookingDao.deleteById(bookingId);
    }
}
