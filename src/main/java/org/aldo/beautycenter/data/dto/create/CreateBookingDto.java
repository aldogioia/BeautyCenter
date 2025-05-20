package org.aldo.beautycenter.data.dto.create;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidBookingInfo;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidOperatorId;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidServiceId;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidCustomerId;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
@ValidBookingInfo
public class CreateBookingDto {
    @NotNull(message = "La data è obbligatoria")
    @FutureOrPresent(message = "La data non può essere nel passato")
    private LocalDate date;

    @JsonFormat(pattern = "HH:mm")
    @NotNull(message = "L'orario è obbligatorio")
    private LocalTime time;

    @NotNull(message = "Il servizio è obbligatorio")
    @ValidServiceId
    private String service;

    @NotNull(message = "L'operatore è obbligatorio")
    @ValidOperatorId
    private String operator;

    @ValidCustomerId
    private String bookedForCustomer;

    @Size(min = 3, max = 50, message = "Il nome deve essere lungo almeno 3 caratteri")
    private String bookedForName;

    @Pattern(regexp = "^\\+?[0-9]{10}$", message = "Il numero di telefono deve contenere 10 numeri")
    private String bookedForNumber;
}
