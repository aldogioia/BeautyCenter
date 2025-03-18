package org.aldo.beautycenter.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.UpdateUserDto;
import org.aldo.beautycenter.security.availability.RateLimit;
import org.aldo.beautycenter.security.customAnnotation.ValidUserId;
import org.aldo.beautycenter.service.interfaces.UserService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RateLimit(permitsPerSecond = 10)
@RestController
@RequestMapping("/api/v1/user")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
@Validated
public class UserController {
    private final UserService userService;
    @PatchMapping
    public void updateUser(@Valid @RequestBody UpdateUserDto updateUserDto) {
        userService.updateUser(updateUserDto);
    }

    @DeleteMapping
    public void deleteUser(@ValidUserId @RequestParam String id) {
        userService.deleteUser(id);
    }
}
