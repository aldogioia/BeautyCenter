package org.aldo.beautycenter.service.implemetations;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.ToolDao;
import org.aldo.beautycenter.data.dto.create.CreateToolDto;
import org.aldo.beautycenter.data.dto.responses.ToolDto;
import org.aldo.beautycenter.data.dto.updates.UpdateToolDto;
import org.aldo.beautycenter.data.entities.Tool;
import org.aldo.beautycenter.service.interfaces.ToolService;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ToolServiceImpl implements ToolService {
    private final ToolDao toolDao;
    private final ModelMapper modelMapper;

    @Override
    public List<ToolDto> getAllTools() {
        return toolDao.findAll()
                .stream()
                .map(tool -> modelMapper.map(tool, ToolDto.class))
                .toList();
    }

    @Override
    public ToolDto createTool(CreateToolDto createToolDto) {
        Tool tool = modelMapper.map(createToolDto, Tool.class);
        toolDao.save(tool);
        return modelMapper.map(tool, ToolDto.class);
    }

    @Override
    public void updateTool(UpdateToolDto updateToolDto) {
        Tool tool = toolDao.findById(updateToolDto.getId())
                .orElseThrow(() -> new EntityNotFoundException("Macchinario non trovato"));
        modelMapper.map(updateToolDto, tool);
        toolDao.save(tool);
    }

    @Override
    public void deleteTool(String toolId) {
        Tool tool = toolDao.findById(toolId)
                .orElseThrow(() -> new EntityNotFoundException("Macchinario non trovato"));

        if (tool.getServices() != null){
            tool.getServices().forEach(service -> service.getTools().remove(tool));
            tool.getServices().clear();
        }

        toolDao.delete(tool);
    }
}
