package org.aldo.beautycenter.security.customAnnotation.annotation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import org.aldo.beautycenter.security.customAnnotation.validator.CustomerIdValidator;

import java.lang.annotation.*;

@Constraint(validatedBy = CustomerIdValidator.class)
@Target({ ElementType.FIELD, ElementType.METHOD, ElementType.PARAMETER })
@Retention(RetentionPolicy.RUNTIME)
public @interface ValidCustomerId {
    String message() default "Id del cliente non valido";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
