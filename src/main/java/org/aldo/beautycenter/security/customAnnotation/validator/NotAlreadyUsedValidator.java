package org.aldo.beautycenter.security.customAnnotation.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.UserDao;
import org.aldo.beautycenter.data.entities.User;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidPhoneNumber;

import java.util.Optional;

@RequiredArgsConstructor
public class NotAlreadyUsedValidator implements ConstraintValidator<ValidPhoneNumber, User> {
    private final UserDao userDao;

    @Override
    public boolean isValid(User user, ConstraintValidatorContext constraintValidatorContext) {
        Optional<User> userOptional = userDao.findByPhoneNumber(user.getPhoneNumber());
        return userOptional.map(value -> value.getId().equals(user.getId())).orElse(true);
    }
}
