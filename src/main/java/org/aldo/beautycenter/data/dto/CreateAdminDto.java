package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.*;
import lombok.Data;

@Data
public class CreateAdminDto {
    @NotBlank
    @Size(min = 3, max = 50)
    private String name;

    @NotBlank
    @Size(min = 3, max = 50)
    private String surname;

    @Email
    private String email;

    //TODO @Pattern(regexp = "")
    private String password;
}
