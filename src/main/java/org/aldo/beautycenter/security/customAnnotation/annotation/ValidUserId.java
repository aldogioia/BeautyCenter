package org.aldo.beautycenter.security.customAnnotation.annotation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import org.aldo.beautycenter.security.customAnnotation.validator.UserIdValidator;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Constraint(validatedBy = UserIdValidator.class)
@Target({ ElementType.FIELD, ElementType.METHOD, ElementType.PARAMETER })
@Retention(RetentionPolicy.RUNTIME)
public @interface ValidUserId {
    String message() default "Id dell'utente non valido";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
