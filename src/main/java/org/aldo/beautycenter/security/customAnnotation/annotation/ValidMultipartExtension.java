package org.aldo.beautycenter.security.customAnnotation.annotation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import org.aldo.beautycenter.security.customAnnotation.validator.MultipartExtensionValidator;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Constraint(validatedBy = MultipartExtensionValidator.class)
@Target({ ElementType.FIELD })
@Retention(RetentionPolicy.RUNTIME)
public @interface ValidMultipartExtension {
    String message() default "Invalid image file extension. Allowed extensions are: jpg, jpeg, png";  //messaggio inutile perchè lancio un'eccezione personalizzata
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
