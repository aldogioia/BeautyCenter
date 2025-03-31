package org.aldo.beautycenter.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.CreateScheduleExceptionDto;
import org.aldo.beautycenter.data.dto.ScheduleExceptionDto;
import org.aldo.beautycenter.data.dto.UpdateScheduleExceptionDto;
import org.aldo.beautycenter.security.availability.RateLimit;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidScheduleExceptionId;
import org.aldo.beautycenter.service.interfaces.ScheduleExceptionService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RateLimit(permitsPerSecond = 10)
@RestController
@RequestMapping("/api/v1/schedule-exception")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
@Validated
public class ScheduleExceptionController {
    private final ScheduleExceptionService scheduleExceptionService;

    @GetMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<List<ScheduleExceptionDto>> getOperatorScheduleExceptions(
            @RequestParam String operatorId
    ) {
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(scheduleExceptionService.getOperatorScheduleExceptions(operatorId));
    }
    @PostMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<HttpStatus> createScheduleExceptions(
            @Valid @RequestBody List<CreateScheduleExceptionDto> createScheduleExceptionDto
    ) {
        scheduleExceptionService.createScheduleExceptions(createScheduleExceptionDto);
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .build();
    }
    @PutMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<HttpStatus> updateScheduleExceptions(
            @Valid @RequestBody List<UpdateScheduleExceptionDto> updateScheduleExceptionDto
    ) {
        scheduleExceptionService.updateScheduleExceptions(updateScheduleExceptionDto);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }
    @DeleteMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<HttpStatus> deleteScheduleExceptions(
            @ValidScheduleExceptionId @RequestParam List<String> scheduleExceptionsIds
    ) {
        scheduleExceptionService.deleteScheduleExceptions(scheduleExceptionsIds);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }
}
