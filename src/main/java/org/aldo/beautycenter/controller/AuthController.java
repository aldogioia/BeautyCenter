package org.aldo.beautycenter.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.CreateCustomerDto;
import org.aldo.beautycenter.security.availability.RateLimit;
import org.aldo.beautycenter.service.interfaces.AuthService;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RateLimit(permitsPerSecond = 10)
@RestController
@RequestMapping("/api/v1/auth")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class AuthController {
    private final AuthService authService;

    @PostMapping("/sign-in")
    public ResponseEntity<HttpStatus> login(
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            HttpServletResponse response
    ) {
        String Token = authService.signIn(email, password);
        response.addHeader(HttpHeaders.AUTHORIZATION,"Bearer " + Token);
        return ResponseEntity
                .status(HttpStatus.OK)
                .build();
    }

    @PostMapping("/sign-up")
    public ResponseEntity<HttpStatus> register(
            @Valid @RequestBody CreateCustomerDto createCustomerDto
    ) {
        authService.signUp(createCustomerDto);
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .build();
    }

    @PostMapping("/sign-out")
    public ResponseEntity<HttpStatus> logout(HttpServletRequest request) {
        authService.signOut(request);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }
}
