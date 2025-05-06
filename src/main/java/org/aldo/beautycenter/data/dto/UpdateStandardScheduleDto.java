package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.aldo.beautycenter.data.dto.superClass.StandardScheduleAbstract;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidStandardScheduleId;

@Data
@EqualsAndHashCode(callSuper = true)
public class UpdateStandardScheduleDto extends StandardScheduleAbstract {
    @NotNull(message = "L'id è obbligatorio")
    @ValidStandardScheduleId
    private String id;
}
