package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.CreateScheduleExceptionDto;
import org.aldo.beautycenter.data.dto.ScheduleExceptionDto;

import java.util.List;

public interface ScheduleExceptionService {
    List<ScheduleExceptionDto> getOperatorScheduleExceptions(String operatorId);
    List<ScheduleExceptionDto> createScheduleExceptions(List<CreateScheduleExceptionDto> createScheduleExceptionDto);
//    void updateScheduleExceptions(List<UpdateScheduleExceptionDto> createScheduleExceptionDto);
    void deleteScheduleExceptions(List<String> ids);
}
