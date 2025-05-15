package org.aldo.beautycenter.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.create.CreateFcmToken;
import org.aldo.beautycenter.security.authorization.CustomUserDetails;
import org.aldo.beautycenter.security.availability.RateLimit;
import org.aldo.beautycenter.service.interfaces.NotificationService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RateLimit(permitsPerSecond = 10)
@RestController
@RequestMapping("/api/v1/notifications")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class NotificationController {
    private final NotificationService notificationService;

    @PostMapping
    public ResponseEntity<HttpStatus> registerToken(
            @Valid @RequestBody CreateFcmToken createFcmToken,
            @AuthenticationPrincipal CustomUserDetails customUserDetails
    ) {
        notificationService.saveToken(createFcmToken, customUserDetails.user());
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .build();
    }
}
