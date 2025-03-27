package org.aldo.beautycenter.security.customAnnotation.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.ServiceDao;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidServiceId;

@RequiredArgsConstructor
public class ServiceIdValidator  implements ConstraintValidator<ValidServiceId, String> {
    private final ServiceDao serviceDao;

    @Override
    public boolean isValid(String serviceId, ConstraintValidatorContext context) {
        return serviceDao.existsById(serviceId);
    }
}
