package org.aldo.beautycenter.data.dto.abstracts;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidPeriod;

import java.time.LocalDate;

@Data
@EqualsAndHashCode(callSuper = true)
@ValidPeriod
public abstract class SchedulePeriodAbstract extends ScheduleAbstract{
    @NotNull(message = "La data è obbligatoria")
    @FutureOrPresent(message = "La data di inizio non può essere nel passato")
    private LocalDate startDate;

    @FutureOrPresent(message = "La data di fine non può essere nel passato")
    private LocalDate endDate;
}
