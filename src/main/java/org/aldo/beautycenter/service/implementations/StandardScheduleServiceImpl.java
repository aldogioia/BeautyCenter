package org.aldo.beautycenter.service.implementations;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.StandardScheduleDao;
import org.aldo.beautycenter.data.dto.create.CreateStandardScheduleDto;
import org.aldo.beautycenter.data.dto.responses.StandardScheduleDto;
import org.aldo.beautycenter.data.dto.updates.UpdateStandardScheduleDto;
import org.aldo.beautycenter.data.entities.StandardSchedule;
import org.aldo.beautycenter.service.interfaces.StandardScheduleService;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class StandardScheduleServiceImpl implements StandardScheduleService {
    private final StandardScheduleDao standardScheduleDao;
    private final ModelMapper modelMapper;

    @Override
    public List<StandardScheduleDto> getOperatorStandardSchedules(String operatorId) {
        return standardScheduleDao.findAllByOperatorId(operatorId)
                .stream()
                .map(standardSchedule -> modelMapper.map(standardSchedule, StandardScheduleDto.class))
                .toList();
    }

    @Override
    public StandardScheduleDto createSchedule(CreateStandardScheduleDto createStandardScheduleDto) {
        StandardSchedule standardSchedule =modelMapper.map(createStandardScheduleDto, StandardSchedule.class);
        standardScheduleDao.save(standardSchedule);

        return modelMapper.map(standardSchedule, StandardScheduleDto.class);
    }

    @Override
    public void updateSchedule(UpdateStandardScheduleDto updateStandardScheduleDto) {
        StandardSchedule standardSchedule = standardScheduleDao.findById(updateStandardScheduleDto.getId())
                            .orElseThrow(() -> new EntityNotFoundException("Turno standard non trovato"));

        modelMapper.map(updateStandardScheduleDto, standardSchedule);
        standardScheduleDao.save(standardSchedule);
    }

    @Override
    public void deleteSchedule(String standardScheduleId) {
        standardScheduleDao.deleteById(standardScheduleId);
    }
}
