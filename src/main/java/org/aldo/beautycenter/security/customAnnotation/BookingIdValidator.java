package org.aldo.beautycenter.security.customAnnotation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.BookingDao;

@RequiredArgsConstructor
public class BookingIdValidator implements ConstraintValidator<ValidBookingId, String> {
    private final BookingDao bookingDao;
    @Override
    public boolean isValid(String bookingId, ConstraintValidatorContext context) {
        return bookingDao.existsById(bookingId);
    }
}
