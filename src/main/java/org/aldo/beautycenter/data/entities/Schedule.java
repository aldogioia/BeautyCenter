package org.aldo.beautycenter.data.entities;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.aldo.beautycenter.security.logging.Auditable;
import org.hibernate.annotations.UuidGenerator;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.DayOfWeek;
import java.time.LocalTime;

@Entity
@Data
@Table(name = "schedule")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "schedule_type", discriminatorType = DiscriminatorType.STRING)
@NoArgsConstructor
@EqualsAndHashCode(callSuper = true)
@EntityListeners(AuditingEntityListener.class)
public class Schedule extends Auditable {
    @Id
    @UuidGenerator
    private String id;

    @Column(name = "day", nullable = false)
    private DayOfWeek day;

    @Column(name = "morning_start_time")
    private LocalTime morningStart;

    @Column(name = "morning_end_time")
    private LocalTime morningEnd;

    @Column(name = "afternoon_start_time")
    private LocalTime afternoonStart;

    @Column(name = "afternoon_end_time")
    private LocalTime afternoonEnd;

    @ManyToOne
    @JoinColumn(name = "operator_id", nullable = false)
    @ToString.Exclude
    private Operator operator;
}
