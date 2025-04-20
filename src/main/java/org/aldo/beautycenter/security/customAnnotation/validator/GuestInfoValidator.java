package org.aldo.beautycenter.security.customAnnotation.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import org.aldo.beautycenter.data.dto.CreateBookingDto;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidGuestInfo;

public class GuestInfoValidator implements ConstraintValidator<ValidGuestInfo, CreateBookingDto> {
    @Override
    public boolean isValid(CreateBookingDto createBookingDto, ConstraintValidatorContext constraintValidatorContext) {
        boolean hasName = createBookingDto.getNameGuest() != null && !createBookingDto.getNameGuest().isBlank();
        boolean hasPhone = createBookingDto.getPhoneNumberGuest() != null && !createBookingDto.getPhoneNumberGuest().isBlank();

        return hasName == hasPhone;
    }
}
