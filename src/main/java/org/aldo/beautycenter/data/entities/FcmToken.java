package org.aldo.beautycenter.data.entities;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import org.aldo.beautycenter.security.logging.Auditable;
import org.hibernate.annotations.UuidGenerator;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

@Entity
@Table(name = "fcm_token")
@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper = true)
@EntityListeners(AuditingEntityListener.class)
public class FcmToken extends Auditable {
    @Id
    @UuidGenerator
    private String id;

    @Column(name="token", nullable = false)
    private String token;

    @Column(name = "platform", nullable = false)
    private String platform;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
}
