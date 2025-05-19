package org.aldo.beautycenter.security.customAnnotation.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.StandardScheduleDao;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidScheduleDay;

import java.time.DayOfWeek;

@RequiredArgsConstructor
public class ScheduleDayValidator implements ConstraintValidator<ValidScheduleDay, DayOfWeek> {
    private final StandardScheduleDao standardScheduleDao;

    @Override
    public boolean isValid(DayOfWeek dayOfWeek, ConstraintValidatorContext constraintValidatorContext) {
        return !standardScheduleDao.existsByDay(dayOfWeek);
    }
}
