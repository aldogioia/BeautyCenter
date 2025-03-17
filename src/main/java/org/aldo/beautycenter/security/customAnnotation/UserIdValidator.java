package org.aldo.beautycenter.security.customAnnotation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.UserDao;

@RequiredArgsConstructor
public class UserIdValidator implements ConstraintValidator<ValidUserId, String> {
    private final UserDao userDao;

    @Override
    public boolean isValid(String userId, ConstraintValidatorContext context) {
        return userDao.existsById(userId);
    }
}
