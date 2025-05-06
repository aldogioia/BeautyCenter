package org.aldo.beautycenter.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.create.CreateServiceDto;
import org.aldo.beautycenter.data.dto.responses.ServiceDto;
import org.aldo.beautycenter.data.dto.updates.UpdateServiceDto;
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
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(serviceService.getAllServices());
    }

    @PostMapping(consumes = {"multipart/form-data"})
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<ServiceDto> createService(@Valid @ModelAttribute CreateServiceDto createServiceDto) {
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(serviceService.addService(createServiceDto));
    }

    @PatchMapping(consumes = {"multipart/form-data"})
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<String> updateService(@Valid @ModelAttribute UpdateServiceDto updateServiceDto) {
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(serviceService.updateService(updateServiceDto));
    }

    @DeleteMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<HttpStatus> deleteService(@ValidServiceId @RequestParam String serviceId) {
        serviceService.deleteService(serviceId);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }
}
