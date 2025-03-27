package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
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

    @NotBlank(message = "Il campo telefono non può essere vuoto")
    @Pattern(regexp = "^\\+?39?\\s?\\d{2,4}[\\s.-]?\\d{6,10}$", message = "Inserire un numero di telefono valido")
    private Number phoneNumber;

    @Email(message = "Inserire un indirizzo email valido")
    @NotAlreadyUsed
    private String email;

    @Pattern(regexp = "", message = "") //todo add regex and message
    private String password;
}
