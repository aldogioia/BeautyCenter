package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.CreateStandardScheduleDto;
import org.aldo.beautycenter.data.dto.StandardScheduleDto;
import org.aldo.beautycenter.data.dto.UpdateStandardScheduleDto;

import java.util.List;

public interface StandardScheduleService {
    List<StandardScheduleDto> getOperatorStandardSchedules(String operatorId);
    List<StandardScheduleDto> createSchedules(List<CreateStandardScheduleDto> createStandardScheduleDto);
    void updateSchedules(List<UpdateStandardScheduleDto> createStandardScheduleDto);
    void deleteSchedules(List<String> standardScheduleIds);
}
