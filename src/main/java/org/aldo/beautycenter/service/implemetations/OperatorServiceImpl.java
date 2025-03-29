package org.aldo.beautycenter.service.implemetations;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.*;
import org.aldo.beautycenter.data.dto.CreateOperatorDto;
import org.aldo.beautycenter.data.dto.OperatorDto;
import org.aldo.beautycenter.data.dto.SummaryServiceDto;
import org.aldo.beautycenter.data.dto.UpdateOperatorDto;
import org.aldo.beautycenter.data.entities.Booking;
import org.aldo.beautycenter.data.entities.Operator;
import org.aldo.beautycenter.data.entities.Schedule;
import org.aldo.beautycenter.data.entities.ScheduleException;
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
    private final S3Service s3Service;
    private final OperatorServiceDao operatorServiceDao;
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
                            operator.getOperatorServices().stream()
                                    .map(operatorService -> modelMapper.map(operatorService.getService(), SummaryServiceDto.class))
                                    .toList()
                    );
                    return operatorDto;
                }).toList();
    }

    @Override
    public List<LocalTime> getAvailableHours(String operatorId, LocalDate date, String serviceId) {
        org.aldo.beautycenter.data.entities.Service service = serviceDao.getReferenceById(serviceId);
        List<Booking> operatorBookings = bookingDao.findAllByDateAndOperator_Id(date, operatorId);
        List<Booking> roomBookings = bookingDao.findAllByRoom_RoomServices_Service_Id(serviceId);
        Schedule schedule = scheduleExceptionDao.findByOperatorIdAndDate(operatorId, date)
                .map(s -> (Schedule) s)
                .orElseGet(() -> standardScheduleDao.findByOperatorIdAndDay(operatorId, date.getDayOfWeek()));

        List<LocalTime> availableTimes = new ArrayList<>();
        if(schedule instanceof ScheduleException && ((ScheduleException) schedule).isAbsent()) return availableTimes;

        availableTimes.addAll(getAvailableSlots(schedule.getMorningStart(), schedule.getMorningEnd(), service.getDuration(), operatorBookings, roomBookings));
        availableTimes.addAll(getAvailableSlots(schedule.getAfternoonStart(), schedule.getAfternoonEnd(), service.getDuration(), operatorBookings, roomBookings));

        return availableTimes;
    }

    @Override
    @Transactional
    public void createOperator(CreateOperatorDto createOperatorDto) {
        Operator operator = modelMapper.map(createOperatorDto, Operator.class);
        operatorDao.save(operator);

        createOperatorDto.getServices()
                .forEach(serviceId -> {
                    org.aldo.beautycenter.data.entities.OperatorService operatorService = new org.aldo.beautycenter.data.entities.OperatorService();
                    operatorService.setOperator(operator);
                    operatorService.setService(serviceDao.getReferenceById(serviceId));
                    operatorServiceDao.save(operatorService);
                });
    }

    @Override
    @Transactional
    public void updateOperator(UpdateOperatorDto updateOperatorDto) {
        Operator operator = modelMapper.map(updateOperatorDto, Operator.class);
        if (updateOperatorDto.getImage() != null) //todo da capire se la mando sempre
            operator.setImgUrl(s3Service.uploadFile(updateOperatorDto.getImage(), Constants.OPERATOR_FOLDER, operator.getName()));
        operatorDao.save(operator);

        updateOperatorDto.getServices()
                .forEach(serviceId -> {
                    org.aldo.beautycenter.data.entities.OperatorService operatorService = new org.aldo.beautycenter.data.entities.OperatorService();
                    operatorService.setOperator(operator);
                    operatorService.setService(serviceDao.getReferenceById(serviceId));
                    operatorServiceDao.save(operatorService);
                });
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
