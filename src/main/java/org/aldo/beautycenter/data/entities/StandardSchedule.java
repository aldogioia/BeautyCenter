package org.aldo.beautycenter.data.entities;

import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Entity
@DiscriminatorValue("schedule")
@Data
@EqualsAndHashCode(callSuper = true)
public class StandardSchedule  extends Schedule{
}
