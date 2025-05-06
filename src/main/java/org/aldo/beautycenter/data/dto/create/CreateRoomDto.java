package org.aldo.beautycenter.data.dto.create;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidServiceId;

import java.util.List;

@Data
public class CreateRoomDto {
    @NotBlank(message = "Il campo nome non può essere vuoto")
    @Size(min = 1, max = 50, message = "Il campo nome deve essere lungo tra 1 e 50 caratteri")
    private String name;

    private List<@ValidServiceId String> services;
}
