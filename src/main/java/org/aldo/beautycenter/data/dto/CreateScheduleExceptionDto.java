package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidOperatorId;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;

@Data
public class CreateScheduleExceptionDto {
    @NotNull(message = "Il giorno è obbligatorio")
    @FutureOrPresent(message = "La data non può essere nel passato")
    private LocalDate date;

    @NotNull(message = "Indicare la presenza è obbligatorio")
    private Boolean absent;

    @NotNull(message = "Il giorno della settimana è obbligatorio")
    private DayOfWeek day;

    @NotNull(message = "L'orario di inizio della mattina è obbligatorio")
    private LocalTime morningStart;

    @NotNull(message = "L'orario di fine della mattina è obbligatorio")
    private LocalTime morningEnd;

    @NotNull(message = "L'orario di inizio del pomeriggio è obbligatorio")
    private LocalTime afternoonStart;

    @NotNull(message = "L'orario di fine del pomeriggio è obbligatorio")
    private LocalTime afternoonEnd;

    @NotNull(message = "L'id dell'operatore è obbligatorio")
    @ValidOperatorId
    private String operatorId;
}
