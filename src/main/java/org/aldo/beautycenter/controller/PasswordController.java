package org.aldo.beautycenter.controller;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.updates.UpdatePasswordDto;
import org.aldo.beautycenter.security.availability.RateLimit;
import org.aldo.beautycenter.service.interfaces.PasswordService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
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
    public ResponseEntity<HttpStatus> requestResetPassword(
            @NotNull(message = "Il campo telefono è obligatorio")
            @Pattern(regexp = "^\\+?[0-9]{10}$", message = "Il numero di telefono deve contenere 10 numeri")
            @RequestParam String phoneNumber
    ) {
        passwordService.requestChangePassword(phoneNumber);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }

    @PatchMapping("/reset")
    public ResponseEntity<HttpStatus> resetPassword(
            @RequestParam String token,
            @Pattern(regexp = "^(?=.*\\d).{8,}$", message = "La password deve essere lunga almeno 8 caratteri e contenere almeno un numero") @RequestParam String password) {
        passwordService.changePassword(token, password);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }

    @PatchMapping("/update-password")
    @PreAuthorize("authentication.principal.id == #updatePasswordDto.userId")
    public ResponseEntity<HttpStatus> updatePassword(@Valid @RequestBody UpdatePasswordDto updatePasswordDto) {
        passwordService.updatePassword(updatePasswordDto);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }
}
