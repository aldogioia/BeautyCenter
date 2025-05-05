package org.aldo.beautycenter.security.customAnnotation.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.CustomerDao;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidCustomerId;

@RequiredArgsConstructor
public class CustomerIdValidator implements ConstraintValidator<ValidCustomerId, String> {
    private final CustomerDao customerDao;

    @Override
    public boolean isValid(String userId, ConstraintValidatorContext context) {
        if (userId == null) return true;
        return customerDao.existsById(userId);
    }
}
