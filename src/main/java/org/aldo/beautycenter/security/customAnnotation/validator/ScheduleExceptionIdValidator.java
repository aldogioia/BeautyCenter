package org.aldo.beautycenter.security.customAnnotation.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.ScheduleExceptionDao;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidScheduleExceptionId;

@RequiredArgsConstructor
public class ScheduleExceptionIdValidator implements ConstraintValidator<ValidScheduleExceptionId, String> {
    private final ScheduleExceptionDao scheduleExceptionDao;
    @Override
    public boolean isValid(String scheduleExceptionId, ConstraintValidatorContext constraintValidatorContext) {
        return scheduleExceptionDao.existsById(scheduleExceptionId);
    }
}
