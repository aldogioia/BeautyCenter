package org.aldo.beautycenter.security.customAnnotation.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import org.aldo.beautycenter.data.dto.create.CreateBookingDto;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidBookingInfo;

public class BookingInfoValidator implements ConstraintValidator<ValidBookingInfo, CreateBookingDto> {
    @Override
    public boolean isValid(CreateBookingDto createBookingDto, ConstraintValidatorContext constraintValidatorContext) {
        boolean hasName = createBookingDto.getBookedForName() != null;
        boolean hasNumber = createBookingDto.getBookedForNumber() != null;
        boolean hasCustomer = createBookingDto.getBookedForCustomer() != null;

        return hasCustomer ? !hasName && !hasNumber : hasName && hasNumber;
    }
}
