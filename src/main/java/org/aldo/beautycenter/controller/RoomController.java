package org.aldo.beautycenter.controller;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.create.CreateRoomDto;
import org.aldo.beautycenter.data.dto.responses.RoomDto;
import org.aldo.beautycenter.data.dto.updates.UpdateRoomDto;
import org.aldo.beautycenter.security.availability.RateLimit;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidOperatorId;
import org.aldo.beautycenter.service.interfaces.RoomService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RateLimit(permitsPerSecond = 10)
@RestController
@RequestMapping("/api/v1/room")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
@Validated
public class RoomController {
    private final RoomService roomService;
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/all")
    public ResponseEntity<List<RoomDto>> getAllRooms() {
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(roomService.getAllRooms());
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public ResponseEntity<RoomDto> createRoom(@Valid @RequestBody CreateRoomDto createRoomDto) {
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(roomService.createRoom(createRoomDto));
    }

    @PutMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<HttpStatus> updateRoom(@Valid @RequestBody UpdateRoomDto updateRoomDto) {
        roomService.updateRoom(updateRoomDto);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping
    public ResponseEntity<HttpStatus> deleteRoom(@NotNull @ValidOperatorId @RequestParam String roomId) {
        roomService.deleteRoom(roomId);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }
}
