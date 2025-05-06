package org.aldo.beautycenter.data.dto.abstracts;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidOperatorId;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidStandardScheduleInfo;

import java.time.LocalTime;

@Data
@ValidStandardScheduleInfo
public abstract class StandardScheduleAbstract {
    private LocalTime morningStart;
    private LocalTime morningEnd;
    private LocalTime afternoonStart;
    private LocalTime afternoonEnd;

    @NotNull(message = "L'id dell'operatore è obbligatorio")
    @ValidOperatorId
    private String operatorId;
}

