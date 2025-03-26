package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.ValidServiceId;

import java.util.List;

@Data
public class CreateOperatorDto {
    @NotBlank
    @Size(min = 3, max = 50)
    private String img_url;

    @NotBlank
    @Size(min = 3, max = 50)
    private String name;

    @NotBlank
    @Size(min = 3, max = 50)
    private String surname;

    @Email
    private String email;

    private List<@ValidServiceId String> services;
}
