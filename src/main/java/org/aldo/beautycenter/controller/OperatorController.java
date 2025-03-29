package org.aldo.beautycenter.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.CreateOperatorDto;
import org.aldo.beautycenter.data.dto.OperatorDto;
import org.aldo.beautycenter.data.dto.UpdateOperatorDto;
import org.aldo.beautycenter.security.availability.RateLimit;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidOperatorId;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidServiceId;
import org.aldo.beautycenter.service.interfaces.OperatorService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@RateLimit(permitsPerSecond = 10)
@RestController
@RequestMapping("/api/v1/operator")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
@Validated
public class OperatorController {
    private final OperatorService operatorService;

    @GetMapping("/all")
    public ResponseEntity<List<OperatorDto>> getAllOperators() {
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(operatorService.getAllOperators());
    }

    @GetMapping("/availableHours")
    public ResponseEntity<List<LocalTime>> getAvailableHours(
            @ValidOperatorId @RequestParam String operatorId,
            @RequestParam LocalDate date,
            @ValidServiceId @RequestParam String serviceId
    ) {
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(operatorService.getAvailableHours(operatorId, date, serviceId));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping(consumes = {"multipart/form-data"})
    public ResponseEntity<HttpStatus> createOperator(@Valid @ModelAttribute CreateOperatorDto createOperatorDto) {
        operatorService.createOperator(createOperatorDto);
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .build();
    }

    @PreAuthorize("hasRole('ADMIN') or authentication.principal.id == #updateOperatorDto.id")
    @PatchMapping(consumes = {"multipart/form-data"})
    public ResponseEntity<HttpStatus> updateOperator(@Valid @ModelAttribute UpdateOperatorDto updateOperatorDto) {
        operatorService.updateOperator(updateOperatorDto);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping
    public ResponseEntity<HttpStatus> deleteOperator(@ValidOperatorId @RequestParam String operatorId) {
        operatorService.deleteOperator(operatorId);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }
}
