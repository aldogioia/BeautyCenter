package org.aldo.beautycenter.security.customAnnotation.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.UserDao;
import org.aldo.beautycenter.security.customAnnotation.annotation.NotAlreadyUsed;

@RequiredArgsConstructor
public class NotAlreadyUsedValidator implements ConstraintValidator<NotAlreadyUsed, String> {
    private final UserDao userDao;
    @Override
    public boolean isValid(String email, ConstraintValidatorContext constraintValidatorContext) {
        return userDao.findByEmail(email).isEmpty();
    }
}
