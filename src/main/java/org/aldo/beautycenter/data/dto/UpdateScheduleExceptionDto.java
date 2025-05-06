package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.aldo.beautycenter.data.dto.superClass.ScheduleExceptionAbstract;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidScheduleExceptionId;

@Data
@EqualsAndHashCode(callSuper = true)
public class UpdateScheduleExceptionDto extends ScheduleExceptionAbstract {
    @NotNull(message = "L'id è obbligatorio")
    @ValidScheduleExceptionId
    private String id;
}
