package org.aldo.beautycenter.data.dto.create;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.aldo.beautycenter.data.dto.abstracts.ScheduleAbstract;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidScheduleDay;

import java.time.DayOfWeek;

@Data
@EqualsAndHashCode(callSuper = true)
public class CreateStandardScheduleDto extends ScheduleAbstract {
    @NotNull(message = "Il giorno della settimana è obbligatorio")
    @ValidScheduleDay
    private DayOfWeek day;
}
