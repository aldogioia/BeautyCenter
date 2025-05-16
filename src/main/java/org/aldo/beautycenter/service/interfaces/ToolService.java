package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.create.CreateToolDto;
import org.aldo.beautycenter.data.dto.responses.ToolDto;
import org.aldo.beautycenter.data.dto.updates.UpdateToolDto;

import java.util.List;

public interface ToolService {
    List<ToolDto> getAllTools();
    ToolDto createTool(CreateToolDto createToolDto);
    void updateTool(UpdateToolDto updateToolDto);
    void deleteTool(String toolId);
}
