package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.Size;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.ValidServiceId;

import java.util.List;

@Data
public class CreateRoomDto {
    @Size(min = 1, max = 50)
    private String name;

    private List<@ValidServiceId String> services;
}
