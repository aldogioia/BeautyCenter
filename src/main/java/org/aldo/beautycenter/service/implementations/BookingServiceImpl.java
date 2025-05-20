package org.aldo.beautycenter.service.implementations;

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
import org.aldo.beautycenter.data.enumerators.Role;
import org.aldo.beautycenter.security.exception.customException.BookingConflictException;
import org.aldo.beautycenter.security.exception.customException.BookingDeleteException;
import org.aldo.beautycenter.service.interfaces.BookingService;
import org.aldo.beautycenter.service.interfaces.NotificationService;
import org.aldo.beautycenter.service.interfaces.WhatsAppSenderService;
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
    private final WhatsAppSenderService whatsAppSenderService;
    private final NotificationService notificationService;
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

            if (createBookingDto.getBookedForNumber() != null) {
                whatsAppSenderService.sendConfirmationBooking(booking);
            }

            return modelMapper.map(booking, BookingDto.class);
        }
        catch (Exception e) {
            throw new RuntimeException(e.getMessage());
        }
    }

    @Override
    @Transactional
    public void deleteBooking(String bookingId, User user) {
        try{
            Booking booking = bookingDao.findById(bookingId)
                    .orElseThrow(() -> new EntityNotFoundException("Booking non trovato"));

            final String title = "Appuntamento cancellato";

            if (user.getRole().equals(Role.ROLE_ADMIN)){
                if (booking.getBookedForCustomer() != null) {
                    notificationService.sendNotificationToUser(
                            booking.getBookedForCustomer(),
                            title,
                            "L'appuntamento " + booking.getService().getName() + "in data" + booking.getDate() + " è stato cancellato per un imprevisto"
                    );
                }
                else {
                    whatsAppSenderService.sendCancelBooking(booking);
                }
                bookingDao.delete(booking);
            }
            else if (user.getId().equals(booking.getBookedForCustomer().getId())) {
                notificationService.sendNotificationToUser(
                        booking.getBookedForCustomer(),
                        title,
                        booking.getBookedForCustomer().getName() + booking.getBookedForCustomer().getSurname() + " ha cancellato l'appuntamento" + booking.getService().getName()
                );
                bookingDao.delete(booking);
            }
        }
        catch (Exception e) {
            throw new BookingDeleteException(e.getMessage());
        }
    }
}
