package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.*;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.NotAlreadyUsed;

@Data
public class CreateAdminDto {
    @NotBlank(message = "Il campo nome è obbligatorio")
    @Size(min = 3, max = 50, message = "Il nome deve essere lungo almeno 3 caratteri")
    private String name;

    @NotBlank(message = "Il campo cognome è obbligatorio")
    @Size(min = 3, max = 50, message = "Il cognome deve essere lungo almeno 3 caratteri")
    private String surname;

    @Email(message = "L'email dev'essere valida")
    @NotAlreadyUsed
    private String email;

    //TODO @Pattern(regexp = "", message = "")
    private String password;
}
