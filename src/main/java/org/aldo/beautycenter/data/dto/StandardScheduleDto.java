package org.aldo.beautycenter.data.dto;

import lombok.Data;

import java.time.DayOfWeek;
import java.time.LocalTime;

@Data
public class StandardScheduleDto {
    private String id;
    private DayOfWeek day;
    private LocalTime morningStart;
    private LocalTime morningEnd;
    private LocalTime afternoonStart;
    private LocalTime afternoonEnd;
}
