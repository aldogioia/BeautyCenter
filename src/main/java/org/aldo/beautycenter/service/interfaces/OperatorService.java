package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.CreateOperatorDto;
import org.aldo.beautycenter.data.dto.OperatorDto;
import org.aldo.beautycenter.data.dto.UpdateOperatorDto;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface OperatorService {
    List<OperatorDto> getAllOperators();
    List<LocalTime> getAvailableHours(String operatorId, LocalDate date, String serviceId);

    OperatorDto createOperator(CreateOperatorDto createOperatorDto);

    String updateOperator(UpdateOperatorDto updateOperatorDto);

    void deleteOperator(String operatorId);
}
