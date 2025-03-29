package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.NotAlreadyUsed;
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

    @Email(message = "Inserisci un indirizzo email valido")
    @NotAlreadyUsed
    private String email;

    private List<@ValidServiceId String> services;
}
