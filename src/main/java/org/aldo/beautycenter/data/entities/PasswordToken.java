package org.aldo.beautycenter.data.entities;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.UuidGenerator;

import java.util.Date;

@Entity
@Table(name = "password_token")
@Data
@NoArgsConstructor
public class PasswordToken {
    @Id
    @UuidGenerator
    private String id;

    @Column(name = "token", nullable = false, unique = true)
    private String token;

    @Column(name = "expiration_date", nullable = false)
    private Date expirationDate;

    @OneToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
}
