package org.aldo.beautycenter.data.dto.updates;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.aldo.beautycenter.data.dto.abstracts.ScheduleAbstract;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidStandardScheduleId;

@Data
@EqualsAndHashCode(callSuper = true)
public class UpdateStandardScheduleDto extends ScheduleAbstract {
    @NotNull(message = "L'id è obbligatorio")
    @ValidStandardScheduleId
    private String id;
}
