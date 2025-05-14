package org.aldo.beautycenter.data.dto.create;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CreateFcmToken {
    @NotNull
    @NotBlank
    private String token;

    @NotNull
    @NotBlank
    private String platform;
}
