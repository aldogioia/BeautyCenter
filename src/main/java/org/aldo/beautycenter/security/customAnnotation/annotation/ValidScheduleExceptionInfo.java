package org.aldo.beautycenter.security.customAnnotation.annotation;


import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import org.aldo.beautycenter.security.customAnnotation.validator.ScheduleExceptionInfoValidator;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Constraint(validatedBy = ScheduleExceptionInfoValidator.class)
@Target({ ElementType.TYPE })
@Retention(RetentionPolicy.RUNTIME)
public @interface ValidScheduleExceptionInfo {
    String message() default "Orari del turno non validi";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
