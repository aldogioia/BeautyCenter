package org.aldo.beautycenter.security.customAnnotation.annotation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import org.aldo.beautycenter.security.customAnnotation.validator.PeriodValidator;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Constraint(validatedBy = PeriodValidator.class)
@Target({ ElementType.TYPE })
@Retention(RetentionPolicy.RUNTIME)
public @interface ValidPeriod {
    String message() default "Nella data o nel periodo impostato esiste già un cambio turno.";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
