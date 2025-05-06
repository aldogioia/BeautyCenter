package org.aldo.beautycenter.data.dto.responses;

import lombok.Data;
import org.aldo.beautycenter.data.dto.summaries.SummaryCustomerDto;
import org.aldo.beautycenter.data.dto.summaries.SummaryOperatorDto;

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
