package org.aldo.beautycenter.data.dto;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
public class BookingDto {
    private String id;
    private ServiceDto service;
    private SummaryOperatorDto operator;
    private SummaryCustomerDto customer;
    private String room;
    private LocalDate date;
    private LocalTime time;
}
