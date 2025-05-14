package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.create.CreateStandardScheduleDto;
import org.aldo.beautycenter.data.dto.responses.StandardScheduleDto;
import org.aldo.beautycenter.data.dto.updates.UpdateStandardScheduleDto;

import java.util.List;

public interface StandardScheduleService {
    List<StandardScheduleDto> getOperatorStandardSchedules(String operatorId);

    StandardScheduleDto createSchedule(CreateStandardScheduleDto createStandardScheduleDto);

    void updateSchedule(UpdateStandardScheduleDto createStandardScheduleDto);

    void deleteSchedule(String standardScheduleId);
}
