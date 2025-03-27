package org.aldo.beautycenter.security.customAnnotation.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.CustomerDao;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidUserId;

@RequiredArgsConstructor
public class UserIdValidator implements ConstraintValidator<ValidUserId, String> {
    private final CustomerDao customerDao;

    @Override
    public boolean isValid(String userId, ConstraintValidatorContext context) {
        return customerDao.existsById(userId);
    }
}
