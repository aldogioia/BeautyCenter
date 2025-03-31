package org.aldo.beautycenter.data.dto;

import lombok.Data;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;

@Data
public class ScheduleExceptionDto {
    private String id;
    private LocalDate date;
    private Boolean absent;
    private DayOfWeek day;
    private LocalTime morningStart;
    private LocalTime morningEnd;
    private LocalTime afternoonStart;
    private LocalTime afternoonEnd;
}
