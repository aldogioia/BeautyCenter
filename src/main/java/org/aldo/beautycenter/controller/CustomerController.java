package org.aldo.beautycenter.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.UpdateCustomerDto;
import org.aldo.beautycenter.security.availability.RateLimit;
import org.aldo.beautycenter.security.customAnnotation.ValidUserId;
import org.aldo.beautycenter.service.interfaces.CustomerService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RateLimit(permitsPerSecond = 10)
@RestController
@RequestMapping("/api/v1/user")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
@Validated
public class CustomerController {
    private final CustomerService customerService;
    @PatchMapping
    public void updateUser(@Valid @RequestBody UpdateCustomerDto updateCustomerDto) {
        customerService.updateCustomer(updateCustomerDto);
    }

    @DeleteMapping
    public void deleteUser(@ValidUserId @RequestParam String id) {
        customerService.deleteCustomer(id);
    }
}
