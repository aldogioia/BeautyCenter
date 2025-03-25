package org.aldo.beautycenter.service.implemetations;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.*;
import org.aldo.beautycenter.data.entities.Booking;
import org.aldo.beautycenter.data.entities.Schedule;
import org.aldo.beautycenter.service.interfaces.OperatorService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class OperatorServiceImpl implements OperatorService {
    private final StandardScheduleDao standardScheduleDao;
    private final ScheduleExceptionDao scheduleExceptionDao;
    private final BookingDao bookingDao;
    private final ServiceDao serviceDao;
    @Override
    public List<LocalTime> getAvailableHours(String operatorId, LocalDate date, String serviceId) {
        org.aldo.beautycenter.data.entities.Service service = serviceDao.getReferenceById(serviceId);
        List<Booking> operatorBookings = bookingDao.findAllByDateAndOperator_Id(date, operatorId);
        List<Booking> roomBookings = bookingDao.findAllByRoom_RoomServices_Service_Id(serviceId);
        Schedule schedule = scheduleExceptionDao.findByOperatorIdAndDate(operatorId, date)
                .map(s -> (Schedule) s)
                .orElseGet(() -> standardScheduleDao.findByOperatorIdAndDay(operatorId, date.getDayOfWeek()));

        List<LocalTime> availableTimes = new ArrayList<>();
        availableTimes.addAll(getAvailableSlots(schedule.getMorningStart(), schedule.getMorningEnd(), service.getDuration(), operatorBookings, roomBookings));
        availableTimes.addAll(getAvailableSlots(schedule.getAfternoonStart(), schedule.getAfternoonEnd(), service.getDuration(), operatorBookings, roomBookings));

        return availableTimes;
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
