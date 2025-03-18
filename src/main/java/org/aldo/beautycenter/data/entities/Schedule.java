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
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Data
@Table(name = "schedule")
@NoArgsConstructor
@EqualsAndHashCode(callSuper = true)
@EntityListeners(AuditingEntityListener.class)
public class Schedule extends Auditable {
    @Id
    @UuidGenerator
    private String id;

    @ManyToOne
    @JoinColumn(name = "operator_id", nullable = false)
    @ToString.Exclude
    private Operator operator;

    @Column(name = "date", nullable = false)
    private LocalDate date;

    @Column(name = "day", nullable = false)
    private DayOfWeek day;

    @Column(name = "morning_start_time")
    private LocalTime morningStartTime;

    @Column(name = "morning_end_time")
    private LocalTime morningEndTime;

    @Column(name = "afternoon_start_time")
    private LocalTime afternoonStartTime;

    @Column(name = "afternoon_end_time")
    private LocalTime afternoonEndTime;
}
