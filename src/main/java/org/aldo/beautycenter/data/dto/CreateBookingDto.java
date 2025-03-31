package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidOperatorId;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidServiceId;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidCustomerId;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
public class CreateBookingDto {
    @NotNull(message = "La data è obbligatoria")
    @FutureOrPresent(message = "La data non può essere nel passato")
    private LocalDate date;

    @NotNull(message = "L'orario è obbligatorio")
    private LocalTime time;

    @NotNull(message = "Il servizio è obbligatorio")
    @ValidServiceId
    private String service;

    @NotNull(message = "L'utente è obbligatorio")
    @ValidCustomerId
    private String customer;

    @NotNull(message = "L'operatore è obbligatorio")
    @ValidOperatorId
    private String operator;
}
