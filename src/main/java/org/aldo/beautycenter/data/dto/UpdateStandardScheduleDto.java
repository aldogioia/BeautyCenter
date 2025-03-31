package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidOperatorId;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidStandardScheduleId;

import java.time.DayOfWeek;
import java.time.LocalTime;

@Data
public class UpdateStandardScheduleDto {
    @NotNull(message = "L'id è obbligatorio")
    @ValidStandardScheduleId
    private String id;

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
