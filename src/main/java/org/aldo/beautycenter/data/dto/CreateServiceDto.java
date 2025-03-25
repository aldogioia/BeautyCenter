package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CreateServiceDto {
    @NotNull
    @NotBlank
    private String name;
    @NotNull
    @Min(1)
    private Double price;
    @NotNull
    private Long duration;
}
