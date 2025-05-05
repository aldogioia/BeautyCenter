package org.aldo.beautycenter.data.dto;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
public class BookingDto {
    private String id;
    private LocalDate date;
    private LocalTime time;
    private ServiceDto service;
    private SummaryOperatorDto operator;
    private String room;
    private SummaryCustomerDto bookedForCustomer;
    private String bookedForName;
    private String bookedForNumber;
}
