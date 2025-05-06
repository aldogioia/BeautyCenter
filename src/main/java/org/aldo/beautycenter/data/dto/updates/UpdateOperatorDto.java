package org.aldo.beautycenter.data.dto.updates;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidMultipartExtension;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidOperatorId;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidServiceId;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Data
public class UpdateOperatorDto {
    @NotNull(message = "Il campo id è obbligatorio")
    @ValidOperatorId
    private String id;

    @ValidMultipartExtension
    private MultipartFile image;

    @NotBlank(message = "Il campo nome non può essere vuoto")
    @Size(min = 3, max = 50, message = "Il campo nome deve essere lungo tra 3 e 50 caratteri")
    private String name;

    @NotBlank(message = "Il campo cognome non può essere vuoto")
    @Size(min = 3, max = 50, message = "Il campo cognome deve essere lungo tra 3 e 50 caratteri")
    private String surname;

    @Email(message = "Inserire un indirizzo email valido")
    private String email;

    private List<@ValidServiceId String> services;
}
