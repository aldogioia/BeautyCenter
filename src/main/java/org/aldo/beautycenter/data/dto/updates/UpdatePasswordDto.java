package org.aldo.beautycenter.data.dto.updates;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidUserId;

@Data
public class UpdatePasswordDto {
    @NotNull(message = "L'id è obbligatorio")
    @ValidUserId
    private String userId;

    @NotNull(message = "La vecchia password è obbligatoria")
    private String oldPassword;

    @NotNull(message = "La nuova password è obbligatoria")
    @Pattern(regexp = "^(?=.*\\d).{8,}$", message = "La password deve essere lunga almeno 8 caratteri e contenere almeno un numero")
    private String newPassword;
}
