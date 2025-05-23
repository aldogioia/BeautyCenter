package org.aldo.beautycenter.controller;

import jakarta.validation.Valid;
import jakarta.validation.constraints.FutureOrPresent;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.responses.BookingDto;
import org.aldo.beautycenter.data.dto.create.CreateBookingDto;
import org.aldo.beautycenter.security.authorization.CustomUserDetails;
import org.aldo.beautycenter.security.availability.RateLimit;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidBookingId;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidCustomerId;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidOperatorId;
import org.aldo.beautycenter.service.interfaces.BookingService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RateLimit(permitsPerSecond = 10)
@RestController
@RequestMapping("/api/v1/booking")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
@Validated
public class BookingController {
    private final BookingService bookingService;

    @GetMapping("/customer")
    public ResponseEntity<List<BookingDto>> getCustomerBookings(@ValidCustomerId @RequestParam String customerId) {
        return ResponseEntity.status(HttpStatus.OK)
                .body(bookingService.getCustomerBookings(customerId));
    }

    @GetMapping("/operator")
    @PreAuthorize("hasRole('ROLE_ADMIN') or hasRole('ROLE_OPERATOR')")
    public ResponseEntity<List<BookingDto>> getOperatorBookings(
            @ValidOperatorId @RequestParam String operatorId,
            @FutureOrPresent(message = "La data non può essere nel passato") @RequestParam LocalDate date
    ) {
        return ResponseEntity.status(HttpStatus.OK)
                .body(bookingService.getOperatorBookingsInDate(operatorId, date));
    }

    @PostMapping
    public ResponseEntity<BookingDto> createBooking(@Valid @RequestBody CreateBookingDto createBookingDto) {
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(bookingService.addBooking(createBookingDto));
    }

    @DeleteMapping
    public ResponseEntity<Void> deleteBooking(@ValidBookingId @RequestParam String bookingId, @AuthenticationPrincipal CustomUserDetails customUserDetails) {
        bookingService.deleteBooking(bookingId, customUserDetails.user());
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }
}
