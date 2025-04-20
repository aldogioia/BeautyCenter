package org.aldo.beautycenter.data.dto;

import lombok.Data;

@Data
public class CustomerDto {
    private String id;
    private String name;
    private String surname;
    private String email;
    private String phoneNumber;
}
