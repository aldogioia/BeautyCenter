package org.aldo.beautycenter.data.entities;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.util.List;

@Entity
@DiscriminatorValue("operator")
@Data
@EqualsAndHashCode(callSuper = true)
public class Operator extends User {
    @Column(name = "img_url")
    private String imgUrl;

    @OneToMany(mappedBy = "operator", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<Schedule> schedules;

    @OneToMany(mappedBy = "operator", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<Booking> bookings;

    @ManyToMany
    @ToString.Exclude
    @JoinTable(name = "operator_service", joinColumns = @JoinColumn(name = "operator_id"), inverseJoinColumns = @JoinColumn(name = "service_id"))
    private List<Service> services;
}
