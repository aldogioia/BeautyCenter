package org.aldo.beautycenter.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.CreateStandardScheduleDto;
import org.aldo.beautycenter.data.dto.StandardScheduleDto;
import org.aldo.beautycenter.data.dto.UpdateStandardScheduleDto;
import org.aldo.beautycenter.security.availability.RateLimit;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidStandardScheduleId;
import org.aldo.beautycenter.service.interfaces.StandardScheduleService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RateLimit(permitsPerSecond = 10)
@RestController
@RequestMapping("/api/v1/standard-schedule")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
@Validated
public class StandardScheduleController {
    private final StandardScheduleService standardScheduleService;

    @GetMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<List<StandardScheduleDto>> getOperatorStandardSchedules(
            @RequestParam String operatorId
    ) {
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(standardScheduleService.getOperatorStandardSchedules(operatorId));
    }
    @PostMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<HttpStatus> createStandardSchedules(
            @Valid @RequestBody List<CreateStandardScheduleDto> createStandardScheduleDto
    ) {
        standardScheduleService.createSchedules(createStandardScheduleDto);
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .build();
    }
    @PutMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<HttpStatus> updateStandardSchedules(
            @Valid @RequestBody List<UpdateStandardScheduleDto> updateStandardScheduleDto
    ) {
        standardScheduleService.updateSchedules(updateStandardScheduleDto);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }
    @DeleteMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<HttpStatus> deleteStandardSchedules(
            @ValidStandardScheduleId @RequestParam List<String> standardScheduleIds
    ) {
        standardScheduleService.deleteSchedules(standardScheduleIds);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }
}
