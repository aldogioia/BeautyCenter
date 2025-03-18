package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class CreateCustomerDto {
    @NotBlank
    @Size(min = 3, max = 50)
    private String name;
    @NotBlank
    @Size(min = 3, max = 50)
    private String surname;
    @NotBlank
    @Pattern(regexp = "") //todo add regex
    private String phoneNumber;
    @Email
    private String email;
    @Pattern(regexp = "") //todo add regex
    private String password;
}
