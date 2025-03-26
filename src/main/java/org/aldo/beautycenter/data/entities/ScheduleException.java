package org.aldo.beautycenter.data.entities;

import jakarta.persistence.Column;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDate;

@Entity
@DiscriminatorValue("schedule_exception")
@Data
@EqualsAndHashCode(callSuper = true)
public class ScheduleException extends Schedule{
    @Column(name = "date", nullable = false)
    private LocalDate date;

    @Column(name="absent", nullable = false)
    private boolean absent;
}
