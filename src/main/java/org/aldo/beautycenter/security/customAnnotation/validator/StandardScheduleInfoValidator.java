package org.aldo.beautycenter.security.customAnnotation.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import org.aldo.beautycenter.data.dto.superClass.StandardScheduleAbstract;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidStandardScheduleInfo;

import java.time.LocalTime;

public class StandardScheduleInfoValidator implements ConstraintValidator<ValidStandardScheduleInfo, StandardScheduleAbstract> {

    @Override
    public boolean isValid(StandardScheduleAbstract schedule, ConstraintValidatorContext constraintValidatorContext) {
        boolean morning = scheduleValid(schedule.getMorningStart(), schedule.getMorningEnd());
        boolean afternoon = scheduleValid(schedule.getAfternoonStart(), schedule.getAfternoonEnd());
        return morning && afternoon;
    }

    boolean scheduleValid(LocalTime start, LocalTime end) {
        if (start == null && end == null) return true;
        if (start != null && end != null) return !start.isAfter(end);
        return false;
    }
}
