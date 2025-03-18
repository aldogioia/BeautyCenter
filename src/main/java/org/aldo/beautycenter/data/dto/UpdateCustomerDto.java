package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.ValidUserId;

@Data
public class UpdateCustomerDto {
    @ValidUserId
    private String id;
    @NotNull
    private Integer phoneNumber;
    @Email
    private String email;
}
