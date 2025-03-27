package org.aldo.beautycenter.security.customAnnotation.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.OperatorDao;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidOperatorId;

@RequiredArgsConstructor
public class OperatorIdValidator implements ConstraintValidator<ValidOperatorId, String> {
    private final OperatorDao operatorDao;
    @Override
    public boolean isValid(String operatorId, ConstraintValidatorContext constraintValidatorContext) {
        return operatorDao.existsById(operatorId);
    }
}
