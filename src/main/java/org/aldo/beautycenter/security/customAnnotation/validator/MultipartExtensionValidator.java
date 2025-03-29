package org.aldo.beautycenter.security.customAnnotation.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidMultipartExtension;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public class MultipartExtensionValidator implements ConstraintValidator<ValidMultipartExtension, MultipartFile> {
    private final List<String> allowedMimeType = List.of("image/jpeg", "image/png", "image/jpg");
    @Override
    public boolean isValid(MultipartFile file, ConstraintValidatorContext context){
        if(file == null) return true;
        if(!allowedMimeType.contains(file.getContentType())){
            context.disableDefaultConstraintViolation();
            context.buildConstraintViolationWithTemplate("Invalid image file extension. Allowed extensions are: jpg, jpeg, png")
                    .addConstraintViolation();
            return false;
        }
        return true;
    }
}
