package org.aldo.beautycenter.security.customAnnotation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.*;

@Constraint(validatedBy = UserIdValidator.class)
@Target({ ElementType.FIELD, ElementType.METHOD, ElementType.PARAMETER })
@Retention(RetentionPolicy.RUNTIME)
public @interface ValidUserId {
    String message() default "Invalid User Id";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
