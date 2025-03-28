package org.aldo.beautycenter.data.dto;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
public class BookingDto {
    private String Id;
    private SummaryServiceDto service;
    private SummaryOperatorDto operator;
    private LocalDate date;
    private LocalTime time;
}
