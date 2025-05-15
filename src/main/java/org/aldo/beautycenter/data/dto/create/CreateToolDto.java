package org.aldo.beautycenter.data.dto.create;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class CreateToolDto {
    @NotNull
    @Size(min = 1, max = 50)
    private String name;

    @NotNull
    @Min(1)
    private Integer availability;
}
