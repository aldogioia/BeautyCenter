package org.aldo.beautycenter.data.entities;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import org.aldo.beautycenter.security.logging.Auditable;
import org.hibernate.annotations.UuidGenerator;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

@Entity
@Table(name = "operator_service")
@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper = true)
@EntityListeners(AuditingEntityListener.class)
public class OperatorService extends Auditable {
    @Id
    @UuidGenerator
    private String id;

    @ManyToOne
    @JoinColumn(name = "operator_id", nullable = false)
    private Operator operator;

    @ManyToOne
    @JoinColumn(name = "service_id", nullable = false)
    private Service service;
}
