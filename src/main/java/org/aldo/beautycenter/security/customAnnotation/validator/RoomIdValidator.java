package org.aldo.beautycenter.security.customAnnotation.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.RoomDao;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidRoomId;

@RequiredArgsConstructor
public class RoomIdValidator implements ConstraintValidator<ValidRoomId, String> {
    private final RoomDao roomDao;
    @Override
    public boolean isValid(String roomId, ConstraintValidatorContext constraintValidatorContext) {
        return roomDao.existsById(roomId);
    }
}
