package org.aldo.beautycenter.data.entities;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.util.List;

@Entity
@DiscriminatorValue("customer")
@Data
@EqualsAndHashCode(callSuper = true)
public class Customer extends User {

    @Column(name = "phone_number", unique = true)
    private Number phoneNumber;

    @OneToMany(mappedBy = "customer", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @ToString.Exclude
    private List<Booking> bookings;
}
