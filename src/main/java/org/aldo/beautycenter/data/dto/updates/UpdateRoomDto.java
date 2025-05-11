package org.aldo.beautycenter.data.dto.updates;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidRoomId;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidServiceId;

import java.util.List;

@Data
public class UpdateRoomDto {
    @NotNull(message = "Il campo id è obbligatorio")
    @ValidRoomId
    private String id;

    @NotBlank(message = "Il campo nome non può essere vuoto")
    @Size(min = 1, max = 50, message = "Il campo nome deve essere lungo tra 1 e 50 caratteri")
    private String name;

    private List<@ValidServiceId String> services;
}
