package org.aldo.beautycenter.data.dto;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
public class BookingDto {
    private String Id;
    private SummaryServiceDto service;
    private SummaryOperatorDto operator;
    //TODO inserire la stanza
    //TODO inserire il costumer
    private LocalDate date;
    private LocalTime time;
}
