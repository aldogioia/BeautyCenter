package org.aldo.beautycenter.controller;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.security.availability.RateLimit;
import org.aldo.beautycenter.service.interfaces.PasswordService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RateLimit(permitsPerSecond = 10)
@RestController
@RequestMapping("/api/v1/password")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
@Validated
public class PasswordController {
    private final PasswordService passwordService;

    @PostMapping("/request-reset")
    public ResponseEntity<HttpStatus> requestResetPassword(@RequestParam String email) {
        passwordService.requestChangePassword(email);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

    @PostMapping("/reset")
    public ResponseEntity<HttpStatus> resetPassword(@RequestParam String token, @RequestParam String password) { // todo add @Pattern(regexp = "^[a-zA-Z0-9]{8,}$") this is an example of regex
        passwordService.changePassword(token, password);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }
}
