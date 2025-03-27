package org.aldo.beautycenter.security.customAnnotation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Constraint(validatedBy = ServiceIdValidator.class)
@Target({ElementType.TYPE_USE, ElementType.FIELD, ElementType.METHOD, ElementType.PARAMETER })
@Retention(RetentionPolicy.RUNTIME)
public @interface ValidServiceId {
    String message() default "Id del servizio non valido";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
