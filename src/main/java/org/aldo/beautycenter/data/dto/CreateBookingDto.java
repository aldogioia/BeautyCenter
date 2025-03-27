package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidServiceId;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidUserId;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
public class CreateBookingDto {
    @NotNull(message = "La data non può essere nulla")
    @FutureOrPresent(message = "La data non può essere nel passato")
    private LocalDate date;

    @NotNull(message = "L'ora non può essere nulla")
    private LocalTime time;

    @ValidServiceId
    private String serviceId;

    @ValidUserId
    private String userId;
}
