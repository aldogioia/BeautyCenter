package org.aldo.beautycenter.service.implemetations;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.*;
import org.aldo.beautycenter.data.dto.*;
import org.aldo.beautycenter.data.entities.Booking;
import org.aldo.beautycenter.data.entities.Operator;
import org.aldo.beautycenter.data.entities.Schedule;
import org.aldo.beautycenter.data.entities.ScheduleException;
import org.aldo.beautycenter.security.exception.customException.EmailAlreadyUsed;
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
    private final StandardScheduleDao standardScheduleDao;
    private final ScheduleExceptionDao scheduleExceptionDao;
    private final ModelMapper modelMapper;

    @Override
    public List<OperatorDto> getAllOperators() {
        return operatorDao.findAll()
                .stream()
                .map(operator -> {
                    OperatorDto operatorDto = modelMapper.map(operator, OperatorDto.class);
                    operatorDto.setServices(
                            operator.getServices().stream()
                                    .map(service -> modelMapper.map(service, SummaryServiceDto.class)).toList()
                    );
                    return operatorDto;
                }).toList();
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
        org.aldo.beautycenter.data.entities.Service service = serviceDao.getReferenceById(serviceId);
        List<Booking> operatorBookings = bookingDao.findAllByDateAndOperator_Id(date, operatorId);
        List<Booking> roomBookings = bookingDao.findAllByRoom_Services_Id(serviceId);
        Schedule schedule = scheduleExceptionDao.findByOperatorIdAndDate(operatorId, date)
                .map(s -> (Schedule) s)
                .orElseGet(() -> standardScheduleDao.findByOperatorIdAndDay(operatorId, date.getDayOfWeek()));

        List<LocalTime> availableTimes = new ArrayList<>();
        if(schedule instanceof ScheduleException && ((ScheduleException) schedule).getAbsent()) return availableTimes;

        availableTimes.addAll(getAvailableSlots(schedule.getMorningStart(), schedule.getMorningEnd(), service.getDuration(), operatorBookings, roomBookings));
        availableTimes.addAll(getAvailableSlots(schedule.getAfternoonStart(), schedule.getAfternoonEnd(), service.getDuration(), operatorBookings, roomBookings));

        return availableTimes;
    }

    @Override
    @Transactional
    public OperatorDto createOperator(CreateOperatorDto createOperatorDto) {
        Operator operator = modelMapper.map(createOperatorDto, Operator.class);
        operator.setImgUrl(s3Service.uploadFile(createOperatorDto.getImage(), Constants.OPERATOR_FOLDER, createOperatorDto.getName()));
        operator.setServices(serviceDao.findAllById(createOperatorDto.getServices()));
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
        operator.setServices(serviceDao.findAllById(updateOperatorDto.getServices()));
        if (updateOperatorDto.getImage() != null)
            operator.setImgUrl(s3Service.uploadFile(updateOperatorDto.getImage(), Constants.OPERATOR_FOLDER, operator.getName()));
        operatorDao.save(operator);
        return operator.getImgUrl();
    }

    @Override
    public void deleteOperator(String operatorId) {
        operatorDao.deleteById(operatorId);
    }

    private List<LocalTime> getAvailableSlots(LocalTime start, LocalTime end, Long duration, List<Booking> operatorBookings, List<Booking> roomBookings) {
        List<LocalTime> slots = new ArrayList<>();
        if (start == null || end == null) return slots;

        for (LocalTime time = start; time.isBefore(end); time = time.plusMinutes(duration)) {
            LocalTime slotStart = time;
            LocalTime slotEnd = time.plusMinutes(duration);

            boolean isOperatorAvailable = operatorBookings
                    .stream()
                    .noneMatch(booking -> isOverlapping(booking.getTime().plusMinutes(booking.getService().getDuration()), slotStart, slotEnd));

            boolean isRoomAvailable =  roomBookings
                    .stream()
                    .noneMatch(booking -> isOverlapping(booking.getTime().plusMinutes(booking.getService().getDuration()), slotStart, slotEnd));

            if (isOperatorAvailable && isRoomAvailable) slots.add(time);
        }
        return slots;
    }

    private boolean isOverlapping(LocalTime bookingTime, LocalTime start, LocalTime end) {
        return !bookingTime.isBefore(start) && bookingTime.isBefore(end);
    }
}
