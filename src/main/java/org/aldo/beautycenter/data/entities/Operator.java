package org.aldo.beautycenter.data.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import org.hibernate.annotations.UuidGenerator;

@Entity
public class Operator {
    @Id
    @UuidGenerator
    private String id;

    //ho aggiunto queste cose altrimenti non potevo fare il metodo nel SrviceService
}
