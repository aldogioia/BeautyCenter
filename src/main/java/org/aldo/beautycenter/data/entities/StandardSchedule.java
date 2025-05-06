package org.aldo.beautycenter.data.entities;

import jakarta.persistence.Column;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.DayOfWeek;

@Entity
@DiscriminatorValue("standard_schedule")
@Data
@EqualsAndHashCode(callSuper = true)
public class StandardSchedule  extends Schedule{
    @Column(name = "day")
    private DayOfWeek day;
}
