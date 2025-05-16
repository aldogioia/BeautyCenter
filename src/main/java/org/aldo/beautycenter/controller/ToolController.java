package org.aldo.beautycenter.controller;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.create.CreateToolDto;
import org.aldo.beautycenter.data.dto.responses.ToolDto;
import org.aldo.beautycenter.data.dto.updates.UpdateToolDto;
import org.aldo.beautycenter.security.availability.RateLimit;
import org.aldo.beautycenter.service.interfaces.ToolService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RateLimit(permitsPerSecond = 10)
@RestController
@RequestMapping("/api/v1/tool")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
@Validated
public class ToolController {
    private final ToolService toolService;

    @GetMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<List<ToolDto>> getAllTools() {
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(toolService.getAllTools());
    }

    @PostMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<ToolDto> createTool(@Valid @RequestBody CreateToolDto createToolDto) {
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(toolService.createTool(createToolDto));
    }

    @PutMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<HttpStatus> updateTool(@Valid @RequestBody UpdateToolDto updateToolDto) {
        toolService.updateTool(updateToolDto);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }

    @DeleteMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<HttpStatus> deleteTool(@NotNull @RequestParam String toolId) {
        toolService.deleteTool(toolId);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }

}
