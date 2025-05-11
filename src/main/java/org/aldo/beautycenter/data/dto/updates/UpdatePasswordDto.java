package org.aldo.beautycenter.data.dto.updates;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidUserId;

@Data
public class UpdatePasswordDto {
    @NotNull
    @ValidUserId
    private String userId;

    @NotNull
    private String oldPassword;

    @NotNull
    @Pattern(regexp = "^(?=.*\\d).{8,}$", message = "La password deve essere lunga almeno 8 caratteri e contenere almeno un numero")
    private String newPassword;
}
