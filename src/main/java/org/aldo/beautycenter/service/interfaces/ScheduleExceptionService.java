package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.create.CreateScheduleExceptionDto;
import org.aldo.beautycenter.data.dto.responses.ScheduleExceptionDto;

import java.util.List;

public interface ScheduleExceptionService {
    List<ScheduleExceptionDto> getOperatorScheduleExceptions(String operatorId);
    ScheduleExceptionDto createScheduleException(CreateScheduleExceptionDto createScheduleExceptionDto);
//    void updateScheduleExceptions(List<UpdateScheduleExceptionDto> createScheduleExceptionDto);
    void deleteScheduleException(String scheduleExceptionsId);
}
