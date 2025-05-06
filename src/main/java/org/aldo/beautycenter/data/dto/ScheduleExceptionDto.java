package org.aldo.beautycenter.data.dto;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
public class ScheduleExceptionDto {
    private String id;
    private LocalDate startDate;
    private LocalDate endDate;
    private LocalTime morningStart;
    private LocalTime morningEnd;
    private LocalTime afternoonStart;
    private LocalTime afternoonEnd;
}
