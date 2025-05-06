package org.aldo.beautycenter.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.responses.CustomerDto;
import org.aldo.beautycenter.data.dto.updates.UpdateCustomerDto;
import org.aldo.beautycenter.security.availability.RateLimit;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidCustomerId;
import org.aldo.beautycenter.service.interfaces.CustomerService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RateLimit(permitsPerSecond = 10)
@RestController
@RequestMapping("/api/v1/customer")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
@Validated
public class CustomerController {
    private final CustomerService customerService;

    @GetMapping("/all")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<List<CustomerDto>> getAllCustomers() {
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(customerService.getAllCustomers());
    }

    @GetMapping("/one")
    @PreAuthorize("hasRole('ROLE_ADMIN') or authentication.principal.id == #id")
    public ResponseEntity<CustomerDto> getCustomer(@ValidCustomerId @RequestParam String id) {
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(customerService.getCustomerById(id));
    }

    @PatchMapping
    @PreAuthorize("hasRole('ROLE_ADMIN') or authentication.principal.id == #updateCustomerDto.id")
    public ResponseEntity<HttpStatus> updateUser(@Valid @RequestBody UpdateCustomerDto updateCustomerDto) {
        customerService.updateCustomer(updateCustomerDto);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }

    @DeleteMapping
    @PreAuthorize("hasRole('ROLE_ADMIN') or authentication.principal.id == #id")
    public ResponseEntity<HttpStatus> deleteUser(@ValidCustomerId @RequestParam String id) {
        customerService.deleteCustomer(id);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }
}
