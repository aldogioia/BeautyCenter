package org.aldo.beautycenter.service.implementations;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.ScheduleExceptionDao;
import org.aldo.beautycenter.data.dto.create.CreateScheduleExceptionDto;
import org.aldo.beautycenter.data.dto.responses.ScheduleExceptionDto;
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
    public ScheduleExceptionDto createScheduleException(CreateScheduleExceptionDto createScheduleExceptionDto) {
        ScheduleException scheduleException = modelMapper.map(createScheduleExceptionDto, ScheduleException.class);
        System.out.println(
            "Id: " + scheduleException.getId() +
            "endDate: " + scheduleException.getEndDate() +
            "startDate: " + scheduleException.getStartDate()
        );

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
}
