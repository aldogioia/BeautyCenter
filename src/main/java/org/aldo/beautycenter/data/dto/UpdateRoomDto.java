package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidRoomId;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidServiceId;

import java.util.List;

@Data
public class UpdateRoomDto {
    @NotNull(message = "Il campo id è obbligatorio")
    @ValidRoomId
    private String id;

    private List<@ValidServiceId String> services;
}
