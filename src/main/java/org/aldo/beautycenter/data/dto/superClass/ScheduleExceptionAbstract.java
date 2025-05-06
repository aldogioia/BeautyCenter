package org.aldo.beautycenter.data.dto.superClass;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidOperatorId;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidScheduleExceptionInfo;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
@ValidScheduleExceptionInfo
public abstract class ScheduleExceptionAbstract {
    @NotNull(message = "Il data è obbligatoria")
    @FutureOrPresent(message = "La data di inizio non può essere nel passato")
    private LocalDate startDate;

    @FutureOrPresent(message = "La data di fine non può essere nel passato")
    private LocalDate endDate;

    private LocalTime startTime;
    private LocalTime morningStart;
    private LocalTime morningEnd;
    private LocalTime afternoonStart;
    private LocalTime afternoonEnd;

    @NotNull(message = "L'id dell'operatore è obbligatorio")
    @ValidOperatorId
    private String operatorId;
}
