package org.aldo.beautycenter.security.customAnnotation.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.ToolDao;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidToolId;

@RequiredArgsConstructor
public class ToolIdValidator implements ConstraintValidator<ValidToolId, String> {
    private final ToolDao toolDao;
    @Override
    public boolean isValid(String toolId, ConstraintValidatorContext constraintValidatorContext) {
        return toolDao.existsById(toolId);
    }
}
