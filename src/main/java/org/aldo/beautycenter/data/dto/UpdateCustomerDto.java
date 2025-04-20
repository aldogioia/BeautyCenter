package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.*;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidCustomerId;

@Data
public class UpdateCustomerDto {
    @NotNull(message = "Il campo id è obbligatorio")
    @ValidCustomerId
    private String id;

    @NotBlank(message = "Il campo nome non può essere vuoto")
    @Size(min = 3, max = 50, message = "Il campo nome deve essere compreso tra 3 e 50 caratteri")
    private String name;

    @NotBlank(message = "Il campo cognome non può essere vuoto")
    @Size(min = 3, max = 50, message = "Il campo cognome deve essere compreso tra 3 e 50 caratteri")
    private String surname;

    @NotNull(message = "Il campo telefono è obligatorio")
    @Pattern(regexp = "^\\+?[0-9]{10}$", message = "Il numero di telefono deve contenere 10 numeri")
    private String phoneNumber;

    @Email(message = "Inserire un indirizzo email valido")
    private String email;
}
