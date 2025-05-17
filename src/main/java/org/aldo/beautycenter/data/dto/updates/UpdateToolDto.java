package org.aldo.beautycenter.data.dto.updates;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidToolId;

@Data
public class UpdateToolDto {
    @NotNull
    @ValidToolId
    private String id;

    @NotNull
    @Size(min = 1, max = 50)
    private String name;

    @NotNull
    @Min(0)
    private Integer availability;
}
