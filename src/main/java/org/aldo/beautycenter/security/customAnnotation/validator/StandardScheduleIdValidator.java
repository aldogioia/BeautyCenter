package org.aldo.beautycenter.security.customAnnotation.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.StandardScheduleDao;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidStandardScheduleId;

@RequiredArgsConstructor
public class StandardScheduleIdValidator implements ConstraintValidator<ValidStandardScheduleId, String> {
    private final StandardScheduleDao standardScheduleDao;
    @Override
    public boolean isValid(String standardScheduleId, ConstraintValidatorContext constraintValidatorContext) {
        return standardScheduleDao.existsById(standardScheduleId);
    }
}
