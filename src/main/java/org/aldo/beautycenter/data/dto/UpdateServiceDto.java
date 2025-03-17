package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.ValidServiceId;

import java.time.LocalTime;

@Data
public class UpdateServiceDto {
    @ValidServiceId
    private String id;
    @NotNull
    @NotBlank
    private String name;
    @NotNull
    @Min(1)
    private Double price;
    @NotNull
    private LocalTime duration;
}
