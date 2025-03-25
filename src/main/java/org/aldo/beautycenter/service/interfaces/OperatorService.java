package org.aldo.beautycenter.service.interfaces;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface OperatorService {
    List<LocalTime> getAvailableHours(String operatorId, LocalDate date, String serviceId);
}
