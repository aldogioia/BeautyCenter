package org.aldo.beautycenter.service.implemetations;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.StandardScheduleDao;
import org.aldo.beautycenter.data.dto.CreateStandardScheduleDto;
import org.aldo.beautycenter.data.dto.StandardScheduleDto;
import org.aldo.beautycenter.data.dto.UpdateStandardScheduleDto;
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
    public List<StandardScheduleDto> createSchedules(List<CreateStandardScheduleDto> createStandardScheduleDto) {
        List<StandardSchedule> standardSchedules = createStandardScheduleDto
                .stream()
                .map(standardSchedule -> modelMapper.map(standardSchedule, StandardSchedule.class))
                .toList();
        standardScheduleDao.saveAll(standardSchedules);

        return standardSchedules
                .stream()
                .map(standardSchedule -> modelMapper.map(standardSchedule, StandardScheduleDto.class))
                .toList();
    }

    @Override
    public void updateSchedules(List<UpdateStandardScheduleDto> updateStandardScheduleDto) {
        updateStandardScheduleDto
                .forEach(updateStandardSchedule -> {
                    StandardSchedule standardSchedule = standardScheduleDao.findById(updateStandardSchedule.getId())
                            .orElseThrow(() -> new EntityNotFoundException("Turno standard non trovato"));
                    modelMapper.map(updateStandardSchedule, standardSchedule);
                    standardScheduleDao.save(standardSchedule);
                });
    }

    @Override
    public void deleteSchedules(List<String> standardScheduleIds) {
        standardScheduleDao.deleteAllById(standardScheduleIds);
    }
}
