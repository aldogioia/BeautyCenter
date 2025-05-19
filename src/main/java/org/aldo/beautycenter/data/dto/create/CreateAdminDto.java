package org.aldo.beautycenter.data.dto.create;

import jakarta.validation.constraints.*;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidPhoneNumber;

@Data
@ValidPhoneNumber
public class CreateAdminDto {
    @NotBlank(message = "Il campo nome è obbligatorio")
    @Size(min = 3, max = 50, message = "Il nome deve essere lungo almeno 3 caratteri")
    private String name;

    @NotBlank(message = "Il campo cognome è obbligatorio")
    @Size(min = 3, max = 50, message = "Il cognome deve essere lungo almeno 3 caratteri")
    private String surname;

    @NotNull(message = "Il campo telefono è obligatorio")
    @Pattern(regexp = "^\\+?[0-9]{10}$", message = "Il numero di telefono deve contenere 10 numeri")
    private String phoneNumber;

    @NotNull(message = "Il campo password è obligatorio")
    @Pattern(regexp = "^(?=.*\\d).{8,}$", message = "La password deve essere lunga almeno 8 caratteri e contenere almeno un numero")
    private String password;
}
