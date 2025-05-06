package org.aldo.beautycenter.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.create.CreateAdminDto;
import org.aldo.beautycenter.security.availability.RateLimit;
import org.aldo.beautycenter.service.interfaces.AdminService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RateLimit(permitsPerSecond = 10)
@RestController
@RequestMapping("/api/v1/admin")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class AdminController {
    private final AdminService adminService;

    @PostMapping
    public ResponseEntity<HttpStatus> createAdmin(@Valid @RequestBody CreateAdminDto createAdminDto) {
        adminService.createAdmin(createAdminDto);
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .build();
    }
}
