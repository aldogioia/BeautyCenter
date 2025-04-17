package org.aldo.beautycenter.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.CreateOperatorDto;
import org.aldo.beautycenter.data.dto.OperatorDto;
import org.aldo.beautycenter.data.dto.SummaryOperatorDto;
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

    @GetMapping("/byService")
    public ResponseEntity<List<SummaryOperatorDto>> getOperatorsByService(
            @ValidServiceId @RequestParam String serviceId
    ) {
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(operatorService.getByService(serviceId));
    }

    @GetMapping("/availableTimes")
    public ResponseEntity<List<LocalTime>> getAvailableTimes(
            @ValidOperatorId @RequestParam String operatorId,
            @RequestParam LocalDate date,
            @ValidServiceId @RequestParam String serviceId
    ) {
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(operatorService.getAvailableTimes(operatorId, date, serviceId));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping(consumes = {"multipart/form-data"})
    public ResponseEntity<OperatorDto> createOperator(@Valid @ModelAttribute CreateOperatorDto createOperatorDto) {
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(operatorService.createOperator(createOperatorDto));
    }

    @PreAuthorize("hasRole('ADMIN') or authentication.principal.id == #updateOperatorDto.id")
    @PatchMapping(consumes = {"multipart/form-data"})
    public ResponseEntity<String> updateOperator(@Valid @ModelAttribute UpdateOperatorDto updateOperatorDto) {
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(operatorService.updateOperator(updateOperatorDto));
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
