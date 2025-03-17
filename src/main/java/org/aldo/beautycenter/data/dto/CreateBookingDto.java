package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.ValidServiceId;
import org.aldo.beautycenter.security.customAnnotation.ValidUserId;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
public class CreateBookingDto {
    @NotNull
    @FutureOrPresent
    private LocalDate date;
    @NotNull
    private LocalTime time;
    @ValidServiceId
    private String serviceId;
    @ValidUserId
    private String userId;
}
