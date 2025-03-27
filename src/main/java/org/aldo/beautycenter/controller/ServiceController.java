package org.aldo.beautycenter.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.CreateServiceDto;
import org.aldo.beautycenter.data.dto.OperatorDto;
import org.aldo.beautycenter.data.dto.ServiceDto;
import org.aldo.beautycenter.data.dto.UpdateServiceDto;
import org.aldo.beautycenter.security.availability.RateLimit;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidServiceId;
import org.aldo.beautycenter.service.interfaces.ServiceService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RateLimit(permitsPerSecond = 10)
@RestController
@RequestMapping("/api/v1/service")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
@Validated
public class ServiceController {
    private final ServiceService serviceService;

    @GetMapping("/all")
    public ResponseEntity<List<ServiceDto>> getAllServices() {
        return ResponseEntity.status(HttpStatus.OK)
                .body(serviceService.getAllServices());
    }

    @GetMapping("/operators")
    public ResponseEntity<List<OperatorDto>> getServicesByOperator(@ValidServiceId @RequestParam String serviceId) {
        return ResponseEntity.status(HttpStatus.OK)
                .body(serviceService.getOperatorsByService(serviceId));
    }

    @PostMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<HttpStatus> createService(@Valid @RequestBody CreateServiceDto createServiceDto) {
        serviceService.addService(createServiceDto);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @PatchMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<HttpStatus> updateService(@Valid @RequestBody UpdateServiceDto updateServiceDto) {
        serviceService.updateService(updateServiceDto);
        return ResponseEntity.status(HttpStatus.OK).build();
    }

    @DeleteMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<HttpStatus> deleteService(@ValidServiceId @RequestParam String serviceId) {
        serviceService.deleteService(serviceId);
        return ResponseEntity.status(HttpStatus.OK).build();
    }
}
