package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.*;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.NotAlreadyUsed;

@Data
public class CreateCustomerDto {
    @NotBlank(message = "Il campo nome non può essere vuoto")
    @Size(min = 3, max = 50, message = "Il campo nome deve essere compreso tra 3 e 50 caratteri")
    private String name;

    @NotBlank(message = "Il campo cognome non può essere vuoto")
    @Size(min = 3, max = 50, message = "Il campo cognome deve essere compreso tra 3 e 50 caratteri")
    private String surname;

    @NotNull(message = "Il campo telefono è obligatorio")
    private Number phoneNumber;

    @Email(message = "Inserire un indirizzo email valido")
    @NotAlreadyUsed
    private String email;

    @Pattern(regexp = "^(?=.*\\d).{8,}$", message = "La password deve essere lunga almeno 8 caratteri e contenere almeno un numero")
    private String password;
}
