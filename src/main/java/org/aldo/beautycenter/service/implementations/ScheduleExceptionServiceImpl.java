package org.aldo.beautycenter.service.implementations;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.ScheduleExceptionDao;
import org.aldo.beautycenter.data.dto.create.CreateScheduleExceptionDto;
import org.aldo.beautycenter.data.dto.responses.ScheduleExceptionDto;
import org.aldo.beautycenter.data.entities.ScheduleException;
import org.aldo.beautycenter.service.interfaces.ScheduleExceptionService;
import org.modelmapper.ModelMapper;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
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
    public ScheduleExceptionDto createScheduleException(CreateScheduleExceptionDto createScheduleExceptionDto) {
        ScheduleException scheduleException = modelMapper.map(createScheduleExceptionDto, ScheduleException.class);

        if (createScheduleExceptionDto.getEndDate() == null) {
            scheduleException.setEndDate(scheduleException.getStartDate());
        }

        scheduleExceptionDao.save(scheduleException);

        return modelMapper.map(scheduleException, ScheduleExceptionDto.class);
    }

//    @Override
//    public void updateScheduleExceptions(List<UpdateScheduleExceptionDto> updateStandardScheduleDto) {
//        updateStandardScheduleDto
//                .forEach(updateStandardSchedule -> {
//                    ScheduleException scheduleException = scheduleExceptionDao.findById(updateStandardSchedule.getId())
//                            .orElseThrow(() -> new EntityNotFoundException("Eccezione turno non trovato"));
//                    modelMapper.map(updateStandardSchedule, scheduleException);
//                    scheduleExceptionDao.save(scheduleException);
//                });
//    }

    @Override
    public void deleteScheduleException(String id) {
        scheduleExceptionDao.deleteById(id);
    }

    @Scheduled(cron = "0 0 3 * * *")
    @Transactional
    public void cleanUp() {
        scheduleExceptionDao.deleteAllByEndDateBefore(LocalDate.now());
    }
}
