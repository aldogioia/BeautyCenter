package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.CreateScheduleExceptionDto;
import org.aldo.beautycenter.data.dto.UpdateScheduleExceptionDto;

import java.util.List;

public interface ScheduleExceptionService {
    void createScheduleExceptions(List<CreateScheduleExceptionDto> createScheduleExceptionDto);
    void updateScheduleExceptions(List<UpdateScheduleExceptionDto> createScheduleExceptionDto);
    void deleteScheduleExceptions(List<String> ids);
}
