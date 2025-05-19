package org.aldo.beautycenter.data.dto.create;

import jakarta.validation.constraints.*;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidPhoneNumber;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidMultipartExtension;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidServiceId;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Data
public class CreateOperatorDto {
    @NotNull(message = "Il campo immagine è obbligatorio")
    @ValidMultipartExtension
    private MultipartFile image;

    @NotBlank(message = "Il campo nome non può essere vuoto")
    @Size(min = 3, max = 50, message = "Il nome deve essere compreso tra 3 e 50 caratteri")
    private String name;

    @NotBlank(message = "Il campo cognome non può essere vuoto")
    @Size(min = 3, max = 50, message = "Il cognome deve essere compreso tra 3 e 50 caratteri")
    private String surname;

    @NotNull(message = "Il campo telefono è obligatorio")
    @Pattern(regexp = "^\\+?[0-9]{10}$", message = "Il numero di telefono deve contenere 10 numeri")
    @ValidPhoneNumber
    private String phoneNumber;

    private List<@ValidServiceId String> services;
}
