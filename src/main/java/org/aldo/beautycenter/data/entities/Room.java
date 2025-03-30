package org.aldo.beautycenter.data.entities;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.aldo.beautycenter.security.logging.Auditable;
import org.hibernate.annotations.UuidGenerator;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.util.List;

@Entity
@Data
@Table(name = "room")
@NoArgsConstructor
@EqualsAndHashCode(callSuper = true)
@EntityListeners(AuditingEntityListener.class)
public class Room extends Auditable {
    @Id
    @UuidGenerator
    private String id;

    @Column(name = "name")
    private String name;

    @OneToMany(mappedBy = "room", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @ToString.Exclude
    private List<Booking> bookings;

    @ManyToMany
    @ToString.Exclude
    @JoinTable(name = "room_service", joinColumns = @JoinColumn(name = "room_id"), inverseJoinColumns = @JoinColumn(name = "service_id"))
    private List<Service> services;
}
