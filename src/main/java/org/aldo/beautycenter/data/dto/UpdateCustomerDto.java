package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.NotAlreadyUsed;
import org.aldo.beautycenter.security.customAnnotation.ValidUserId;

@Data
public class UpdateCustomerDto {
    @ValidUserId
    private String id;

    @NotBlank(message = "Il campo telefono non può essere vuoto")
    @Pattern(regexp = "^\\+?39?\\s?\\d{2,4}[\\s.-]?\\d{6,10}$", message = "Inserire un numero di telefono valido")
    private Integer phoneNumber;

    @Email(message = "Inserire un indirizzo email valido")
    @NotAlreadyUsed
    private String email;
}
