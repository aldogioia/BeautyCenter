package org.aldo.beautycenter.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.responses.AuthResponseDto;
import org.aldo.beautycenter.data.dto.create.CreateCustomerDto;
import org.aldo.beautycenter.security.authorization.CustomUserDetails;
import org.aldo.beautycenter.security.availability.RateLimit;
import org.aldo.beautycenter.service.interfaces.AuthService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RateLimit(permitsPerSecond = 10)
@RestController
@RequestMapping("/api/v1/auth")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class AuthController {
    private final AuthService authService;

    @PostMapping("/sign-in")
    public ResponseEntity<AuthResponseDto> login(
            @RequestParam("email") String email,
            @RequestParam("password") String password
    ) {
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(authService.signIn(email, password));
    }

    @PostMapping("/sign-up")
    public ResponseEntity<HttpStatus> register(@Valid @RequestBody CreateCustomerDto createCustomerDto) {
        authService.signUp(createCustomerDto);
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .build();
    }

    @PostMapping("/sign-out")
    public ResponseEntity<HttpStatus> signOut(HttpServletRequest request, @AuthenticationPrincipal CustomUserDetails customUserDetails) {
        authService.signOut(request, "", customUserDetails.user());
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }

    @PostMapping("/refresh")
    public ResponseEntity<String> refreshToken(HttpServletRequest request) {
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(authService.refresh(request));
    }
}
