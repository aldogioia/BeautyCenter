package org.aldo.beautycenter.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.BookingDto;
import org.aldo.beautycenter.security.customAnnotation.ValidBookingId;
import org.aldo.beautycenter.security.customAnnotation.ValidUserId;
import org.aldo.beautycenter.service.interfaces.BookingService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/v1/booking")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
@Validated
public class BookingController {
    private final BookingService bookingService;
    @GetMapping("/all")
    public ResponseEntity<List<BookingDto>> getAllBookings(@ValidUserId @RequestParam String userId) {
        return ResponseEntity.status(HttpStatus.OK)
                .body(bookingService.getUserBookings(userId, LocalDate.now()));
    }
    @PostMapping
    public ResponseEntity<BookingDto> createBooking(@Valid @RequestBody BookingDto bookingDto) {
        bookingService.addBooking(bookingDto);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @DeleteMapping
    public ResponseEntity<Void> deleteBooking(@ValidBookingId @RequestParam String bookingId) {
        bookingService.deleteBooking(bookingId);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }
}
