package org.aldo.beautycenter.security.customAnnotation.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import org.aldo.beautycenter.data.dto.abstracts.ScheduleAbstract;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidScheduleInfo;

import java.time.LocalTime;

public class ScheduleInfoValidator implements ConstraintValidator<ValidScheduleInfo, ScheduleAbstract> {
    @Override
    public boolean isValid(ScheduleAbstract schedule, ConstraintValidatorContext constraintValidatorContext) {
        boolean morning = scheduleValid(schedule.getMorningStart(), schedule.getMorningEnd());
        boolean afternoon = scheduleValid(schedule.getAfternoonStart(), schedule.getAfternoonEnd());
        return morning && afternoon && hoursValid(schedule.getAfternoonStart(), schedule.getMorningEnd());
    }

    boolean scheduleValid(LocalTime start, LocalTime end) {
        if (start == null && end == null) return true;
        if (start != null && end != null) return !start.isAfter(end);
        return false;
    }

    boolean hoursValid(LocalTime startAfternoon, LocalTime endMorning) {
        if (startAfternoon != null && endMorning != null){
            return startAfternoon.isAfter(endMorning);
        }
        return true;
    }
}
