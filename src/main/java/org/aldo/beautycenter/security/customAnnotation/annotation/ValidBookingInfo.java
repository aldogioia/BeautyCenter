package org.aldo.beautycenter.security.customAnnotation.annotation;

import jakarta.validation.Constraint;
import org.aldo.beautycenter.security.customAnnotation.validator.BookingInfoValidator;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Constraint(validatedBy = BookingInfoValidator.class)
@Target({ ElementType.TYPE })
@Retention(RetentionPolicy.RUNTIME)
public @interface ValidBookingInfo {
    String message() default "Informazioni sul cliente non valide";
    Class<?>[] groups() default {};
    Class<? extends jakarta.validation.Payload>[] payload() default {};
}
