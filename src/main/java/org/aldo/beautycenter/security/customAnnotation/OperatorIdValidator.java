package org.aldo.beautycenter.security.customAnnotation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.OperatorDao;

@RequiredArgsConstructor
public class OperatorIdValidator implements ConstraintValidator<ValidOperatorId, String> {
    private final OperatorDao operatorDao;
    @Override
    public boolean isValid(String operatorId, ConstraintValidatorContext constraintValidatorContext) {
        return operatorDao.existsById(operatorId);
    }
}
