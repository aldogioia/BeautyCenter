package org.aldo.beautycenter.controller;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.create.CreateScheduleExceptionDto;
import org.aldo.beautycenter.data.dto.responses.ScheduleExceptionDto;
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
            @NotNull @RequestParam String operatorId
    ) {
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(scheduleExceptionService.getOperatorScheduleExceptions(operatorId));
    }

    @PostMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<ScheduleExceptionDto> createScheduleExceptions(
            @Valid @RequestBody CreateScheduleExceptionDto createScheduleExceptionDto
    ) {
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(scheduleExceptionService.createScheduleException(createScheduleExceptionDto));
    }

//    @PutMapping
//    @PreAuthorize("hasRole('ROLE_ADMIN')")
//    public ResponseEntity<HttpStatus> updateScheduleExceptions(
//            @Valid @RequestBody List<UpdateScheduleExceptionDto> updateScheduleExceptionDto
//    ) {
//        scheduleExceptionService.updateScheduleExceptions(updateScheduleExceptionDto);
//        return ResponseEntity
//                .status(HttpStatus.NO_CONTENT)
//                .build();
//    }

    @DeleteMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<HttpStatus> deleteScheduleExceptions(
            @ValidScheduleExceptionId @RequestParam String scheduleExceptionsId
    ) {
        scheduleExceptionService.deleteScheduleException(scheduleExceptionsId);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }
}
