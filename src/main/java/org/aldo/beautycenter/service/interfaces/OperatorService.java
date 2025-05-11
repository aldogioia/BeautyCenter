package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.create.CreateOperatorDto;
import org.aldo.beautycenter.data.dto.responses.OperatorDto;
import org.aldo.beautycenter.data.dto.summaries.SummaryOperatorDto;
import org.aldo.beautycenter.data.dto.updates.UpdateOperatorDto;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface OperatorService {
    OperatorDto getOperatorById(String operatorId);

    List<OperatorDto> getAllOperators();

    List<SummaryOperatorDto> getByService(String serviceId);

    List<LocalTime> getAvailableTimes(String operatorId, LocalDate date, String serviceId);

    OperatorDto createOperator(CreateOperatorDto createOperatorDto);

    String updateOperator(UpdateOperatorDto updateOperatorDto);

    void deleteOperator(String operatorId);
}
