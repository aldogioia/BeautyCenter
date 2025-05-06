package org.aldo.beautycenter.data.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;
import org.aldo.beautycenter.data.dto.superClass.ScheduleExceptionAbstract;

@Data
@EqualsAndHashCode(callSuper = true)
public class CreateScheduleExceptionDto extends ScheduleExceptionAbstract {
}
