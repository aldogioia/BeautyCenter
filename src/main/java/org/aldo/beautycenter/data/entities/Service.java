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
@Table(name = "service")
@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper = true)
@EntityListeners(AuditingEntityListener.class)
public class Service extends Auditable {
    @Id
    @UuidGenerator
    private String id;

    @Column(name="img_url", nullable = false)
    private String imgUrl;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "price", nullable = false)
    private Double price;

    @Column(name = "duration", nullable = false)
    private Long duration;

    @OneToMany(mappedBy = "service", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @ToString.Exclude
    private List<Booking> bookings;

    @ManyToMany(mappedBy = "services", fetch = FetchType.LAZY)
    @ToString.Exclude
    private List<Room> rooms;

    @ManyToMany(mappedBy = "services", fetch = FetchType.LAZY)
    @ToString.Exclude
    private List<Operator> operators;

    @ManyToMany
    @ToString.Exclude
    @JoinTable(name = "service_tool", joinColumns = @JoinColumn(name = "service_id"), inverseJoinColumns = @JoinColumn(name = "tool_id"))
    private List<Tool> tools;
}
