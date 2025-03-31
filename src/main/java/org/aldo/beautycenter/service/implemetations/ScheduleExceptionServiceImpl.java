package org.aldo.beautycenter.service.implemetations;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.ScheduleExceptionDao;
import org.aldo.beautycenter.data.dto.CreateScheduleExceptionDto;
import org.aldo.beautycenter.data.dto.ScheduleExceptionDto;
import org.aldo.beautycenter.data.dto.UpdateScheduleExceptionDto;
import org.aldo.beautycenter.data.entities.ScheduleException;
import org.aldo.beautycenter.service.interfaces.ScheduleExceptionService;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ScheduleExceptionServiceImpl implements ScheduleExceptionService {
    private final ScheduleExceptionDao scheduleExceptionDao;
    private final ModelMapper modelMapper;

    @Override
    public List<ScheduleExceptionDto> getOperatorScheduleExceptions(String operatorId) {
        return scheduleExceptionDao.findAllByOperatorId(operatorId)
                .stream()
                .map(scheduleException -> modelMapper.map(scheduleException, ScheduleExceptionDto.class))
                .toList();
    }

    @Override
    public void createScheduleExceptions(List<CreateScheduleExceptionDto> createScheduleExceptionDto) {
        List<ScheduleException> scheduleExceptions = createScheduleExceptionDto
                .stream()
                .map(scheduleException -> modelMapper.map(scheduleException, ScheduleException.class))
                .toList();
        scheduleExceptionDao.saveAll(scheduleExceptions);
    }

    @Override
    public void updateScheduleExceptions(List<UpdateScheduleExceptionDto> updateStandardScheduleDto) {
        updateStandardScheduleDto
                .forEach(updateStandardSchedule -> {
                    ScheduleException scheduleException = scheduleExceptionDao.findById(updateStandardSchedule.getId())
                            .orElseThrow(() -> new EntityNotFoundException("Eccezione turno non trovato"));
                    modelMapper.map(updateStandardSchedule, scheduleException);
                    scheduleExceptionDao.save(scheduleException);
                });
    }

    @Override
    public void deleteScheduleExceptions(List<String> ids) {
        scheduleExceptionDao.deleteAllById(ids);
    }
}
