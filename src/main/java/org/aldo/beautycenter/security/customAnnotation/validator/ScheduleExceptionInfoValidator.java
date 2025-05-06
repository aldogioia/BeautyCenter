package org.aldo.beautycenter.security.customAnnotation.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import org.aldo.beautycenter.data.dto.abstracts.ScheduleExceptionAbstract;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidScheduleExceptionInfo;

import java.time.LocalTime;

public class ScheduleExceptionInfoValidator implements ConstraintValidator<ValidScheduleExceptionInfo, ScheduleExceptionAbstract> {
    @Override
    public boolean isValid(ScheduleExceptionAbstract schedule, ConstraintValidatorContext constraintValidatorContext) {
        boolean morning = scheduleValid(schedule.getMorningStart(), schedule.getMorningEnd());
        boolean afternoon = scheduleValid(schedule.getAfternoonStart(), schedule.getAfternoonEnd());
        boolean date = schedule.getEndDate() == null || schedule.getEndDate().isAfter(schedule.getStartDate());

        return morning && afternoon && date;
    }

    boolean scheduleValid(LocalTime start, LocalTime end) {
        if (start == null && end == null) return true;
        else if (start != null && end != null) return !start.isAfter(end);
        return false;
    }
}
