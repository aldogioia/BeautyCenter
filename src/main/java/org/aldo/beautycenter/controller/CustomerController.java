package org.aldo.beautycenter.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.CustomerDto;
import org.aldo.beautycenter.data.dto.UpdateCustomerDto;
import org.aldo.beautycenter.security.availability.RateLimit;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidCustomerId;
import org.aldo.beautycenter.service.interfaces.CustomerService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RateLimit(permitsPerSecond = 10)
@RestController
@RequestMapping("/api/v1/customer")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
@Validated
public class CustomerController {
    private final CustomerService customerService;
    @PatchMapping
    @PreAuthorize("hasRole('ROLE_ADMIN') or authentication.principal.id == #updateCustomerDto.id")
    public ResponseEntity<HttpStatus> updateUser(@Valid @RequestBody UpdateCustomerDto updateCustomerDto) {
        customerService.updateCustomer(updateCustomerDto);
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .build();
    }

    @GetMapping
    public ResponseEntity<CustomerDto> getCustomer(@RequestParam String id) {
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(customerService.getCustomerById(id));
    }

    @DeleteMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<HttpStatus> deleteUser(@ValidCustomerId @RequestParam String id) {
        customerService.deleteCustomer(id);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }
}
