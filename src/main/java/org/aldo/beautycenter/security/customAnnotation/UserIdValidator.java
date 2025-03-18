package org.aldo.beautycenter.security.customAnnotation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.CustomerDao;

@RequiredArgsConstructor
public class UserIdValidator implements ConstraintValidator<ValidUserId, String> {
    private final CustomerDao customerDao;

    @Override
    public boolean isValid(String userId, ConstraintValidatorContext context) {
        return customerDao.existsById(userId);
    }
}
