package org.aldo.beautycenter.service.implemetations;

import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.*;
import org.aldo.beautycenter.data.dto.create.CreateOperatorDto;
import org.aldo.beautycenter.data.dto.responses.OperatorDto;
import org.aldo.beautycenter.data.dto.summaries.SummaryOperatorDto;
import org.aldo.beautycenter.data.dto.updates.UpdateOperatorDto;
import org.aldo.beautycenter.data.entities.Booking;
import org.aldo.beautycenter.data.entities.Operator;
import org.aldo.beautycenter.data.entities.Schedule;
import org.aldo.beautycenter.security.exception.customException.EmailAlreadyUsed;
import org.aldo.beautycenter.security.exception.customException.S3DeleteException;
import org.aldo.beautycenter.service.interfaces.NotificationService;
import org.aldo.beautycenter.service.interfaces.OperatorService;
import org.aldo.beautycenter.service.interfaces.S3Service;
import org.aldo.beautycenter.utils.Constants;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class OperatorServiceImpl implements OperatorService {
    private final OperatorDao operatorDao;
    private final BookingDao bookingDao;
    private final ServiceDao serviceDao;
    private final UserDao userDao;
    private final S3Service s3Service;
    private final NotificationService notificationService;
    private final StandardScheduleDao standardScheduleDao;
    private final ScheduleExceptionDao scheduleExceptionDao;

    private final ModelMapper modelMapper;

    @Override
    public OperatorDto getOperatorById(String operatorId) {
        Operator operator =  operatorDao.findById(operatorId)
                .orElseThrow(() -> new EntityNotFoundException("Operator not found"));

        return modelMapper.map(operator, OperatorDto.class);
    }

    @Override
    public List<OperatorDto> getAllOperators() {
        return operatorDao.findAll()
                .stream()
                .map(operator -> modelMapper.map(operator, OperatorDto.class))
                .toList();
    }

    @Override
    public List<SummaryOperatorDto> getByService(String serviceId) {
        return operatorDao.findAllByServices_Id(serviceId)
                .stream()
                .map(operator -> modelMapper.map(operator, SummaryOperatorDto.class))
                .toList();
    }

    @Override
    public List<LocalTime> getAvailableTimes(String operatorId, LocalDate date, String serviceId) {
        org.aldo.beautycenter.data.entities.Service service = serviceDao.findById(serviceId)
                .orElseThrow(() -> new EntityNotFoundException("Servizio non trovato"));

        List<Booking> allBookings = bookingDao.findAllByDate(date);

        List<Booking> operatorBookings = allBookings.stream()
                .filter(booking -> booking.getOperator().getId().equals(operatorId))
                .toList();

        List<Booking> roomBookings = allBookings.stream()
                .filter(booking -> booking.getRoom().getServices().stream()
                        .anyMatch(s -> s.getId().equals(serviceId)))
                .toList();

        Schedule schedule = scheduleExceptionDao.findByOperatorIdAndDate(operatorId, date)
                .map(s -> (Schedule) s)
                .orElseGet(() -> standardScheduleDao.findByOperatorIdAndDay(operatorId, date.getDayOfWeek())
                        .orElseThrow(() -> new EntityNotFoundException("Nessun turno in questa data")));

        List<LocalTime> availableTimes = new ArrayList<>();

        if (schedule.getMorningStart() != null)
            availableTimes.addAll(getAvailableSlots(
                    schedule.getMorningStart(),
                    schedule.getMorningEnd(),
                    service,
                    operatorBookings,
                    roomBookings,
                    allBookings
            ));

        if (schedule.getAfternoonStart() != null)
            availableTimes.addAll(getAvailableSlots(
                    schedule.getAfternoonStart(),
                    schedule.getAfternoonEnd(),
                    service,
                    operatorBookings,
                    roomBookings,
                    allBookings
            ));

        return availableTimes;
    }


    @Override
    @Transactional
    public OperatorDto createOperator(CreateOperatorDto createOperatorDto) {
        Operator operator = modelMapper.map(createOperatorDto, Operator.class);
        operator.setImgUrl(s3Service.uploadFile(createOperatorDto.getImage(), Constants.OPERATOR_FOLDER, createOperatorDto.getName()));
        operatorDao.save(operator);

        return modelMapper.map(operator, OperatorDto.class);
    }

    @Override
    @Transactional
    public String updateOperator(UpdateOperatorDto updateOperatorDto) {
        userDao.findByEmail(updateOperatorDto.getEmail())
                .ifPresent(user -> {
                    if (!user.getId().equals(updateOperatorDto.getId()))
                        throw new EmailAlreadyUsed("Email già in uso");
                });

        Operator operator = operatorDao.getReferenceById(updateOperatorDto.getId());
        modelMapper.map(updateOperatorDto, operator);

        if (updateOperatorDto.getImage() != null)
            operator.setImgUrl(s3Service.uploadFile(updateOperatorDto.getImage(), Constants.OPERATOR_FOLDER, operator.getName()));

        operatorDao.save(operator);

        return operator.getImgUrl();
    }

    @Override
    @Transactional
    public void deleteOperator(String operatorId) {
        Operator operator = operatorDao.findById(operatorId)
                .orElseThrow(() -> new EntityNotFoundException("Operatore non trovato"));

        String operatorName = operator.getName();

        if (operator.getServices() != null) {
            for (org.aldo.beautycenter.data.entities.Service service : operator.getServices()) {
                service.getOperators().remove(operator);
            }
            operator.getServices().clear();
        }

        notificationService.sendNotificationBeforeDeletingBooking(operator.getBookings());

        operatorDao.delete(operator);

        try {
            s3Service.deleteFile(Constants.OPERATOR_FOLDER, operatorName);
        } catch (Exception e) {
            throw new S3DeleteException("Errore nella cancellazione del file su S3");
        }
    }

    //TODO rimettere a private
    public List<LocalTime> getAvailableSlots(
            LocalTime start,
            LocalTime end,
            org.aldo.beautycenter.data.entities.Service service,
            List<Booking> operatorBookings,
            List<Booking> roomBookings,
            List<Booking> allBookings
    ) {
        List<LocalTime> slots = new ArrayList<>();
        if (start == null || end == null) return slots;

        final int resolution = 5; // minuti tra uno slot e l'altro

        for (LocalTime time = start; time.plusMinutes(service.getDuration()).isBefore(end) || time.plusMinutes(service.getDuration()).equals(end); time = time.plusMinutes(resolution)) {
            LocalTime slotEnd = time.plusMinutes(service.getDuration());

            if (isOperatorAvailable(time, slotEnd, operatorBookings) &&
                    isRoomAvailable(time, slotEnd, roomBookings) &&
                    isToolAvailable(time, slotEnd, service, allBookings)
            ) {
                slots.add(time);
            }
        }

        return slots;
    }

    private boolean isOperatorAvailable(LocalTime slotStart, LocalTime slotEnd, List<Booking> bookings) {
        return bookings.stream().noneMatch(booking -> {
            LocalTime bookingStart = booking.getTime();
            LocalTime bookingEnd = bookingStart.plusMinutes(booking.getService().getDuration());
            return isOverlapping(bookingStart, bookingEnd, slotStart, slotEnd);
        });
    }

    private boolean isRoomAvailable(LocalTime slotStart, LocalTime slotEnd, List<Booking> roomBookings) {
        // almeno UNA stanza che supporta quel servizio dev’essere libera
        return roomBookings.stream().noneMatch(booking -> {
            LocalTime bookingStart = booking.getTime();
            LocalTime bookingEnd = bookingStart.plusMinutes(booking.getService().getDuration());
            return isOverlapping(bookingStart, bookingEnd, slotStart, slotEnd);
        });
    }

    private boolean isToolAvailable(LocalTime slotStart, LocalTime slotEnd, org.aldo.beautycenter.data.entities.Service service, List<Booking> allBookings) {
        return service.getTools().stream().noneMatch(tool -> {
            long count = allBookings.stream()
                    .filter(booking -> {
                        LocalTime bookingStart = booking.getTime();
                        LocalTime bookingEnd = bookingStart.plusMinutes(booking.getService().getDuration());
                        return isOverlapping(bookingStart, bookingEnd, slotStart, slotEnd)
                                && booking.getService().getTools().contains(tool);
                    })
                    .count();

            return count >= tool.getAvailability(); // non è disponibile
        });
    }


    private boolean isOverlapping(LocalTime existingStart, LocalTime existingEnd, LocalTime slotStart, LocalTime slotEnd) {
        return slotStart.isBefore(existingEnd) && existingStart.isBefore(slotEnd);
    }
}
