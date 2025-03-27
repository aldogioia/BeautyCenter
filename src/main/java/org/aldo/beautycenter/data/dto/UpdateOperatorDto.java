package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.NotAlreadyUsed;
import org.aldo.beautycenter.security.customAnnotation.ValidOperatorId;
import org.aldo.beautycenter.security.customAnnotation.ValidServiceId;

import java.util.List;

@Data
public class UpdateOperatorDto {
    @ValidOperatorId
    private String id;

    @NotBlank
    @Size(min = 3, max = 50)
    private String img_url; //todo cambiare in immagine

    @NotBlank(message = "Il campo nome non può essere vuoto")
    @Size(min = 3, max = 50, message = "Il campo nome deve essere lungo tra 3 e 50 caratteri")
    private String name;

    @NotBlank(message = "Il campo cognome non può essere vuoto")
    @Size(min = 3, max = 50, message = "Il campo cognome deve essere lungo tra 3 e 50 caratteri")
    private String surname;

    @Email(message = "Inserire un indirizzo email valido")
    @NotAlreadyUsed
    private String email;

    private List<@ValidServiceId String> services;
}
