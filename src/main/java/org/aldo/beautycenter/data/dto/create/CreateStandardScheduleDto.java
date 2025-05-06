package org.aldo.beautycenter.data.dto.create;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.aldo.beautycenter.data.dto.abstracts.StandardScheduleAbstract;

import java.time.DayOfWeek;

@Data
@EqualsAndHashCode(callSuper = true)
public class CreateStandardScheduleDto extends StandardScheduleAbstract {
    @NotNull(message = "Il giorno della settimana è obbligatorio")
    private DayOfWeek day;
}
