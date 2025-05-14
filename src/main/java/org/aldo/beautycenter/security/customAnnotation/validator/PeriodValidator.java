package org.aldo.beautycenter.security.customAnnotation.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.ScheduleExceptionDao;
import org.aldo.beautycenter.data.dto.abstracts.SchedulePeriodAbstract;
import org.aldo.beautycenter.data.entities.ScheduleException;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidPeriod;

import java.time.LocalDate;
import java.util.List;

@RequiredArgsConstructor
public class PeriodValidator implements ConstraintValidator<ValidPeriod, SchedulePeriodAbstract> {
    private final ScheduleExceptionDao scheduleExceptionDao;

    @Override
    public boolean isValid(SchedulePeriodAbstract exception, ConstraintValidatorContext context) {
        System.out.println("periodValidator");
        LocalDate start = exception.getStartDate();
        LocalDate end = exception.getEndDate();
        String operatorId = exception.getOperatorId();

        if (start == null) return false;

        if (end != null && end.isBefore(start)) return false;

        List<ScheduleException> existingExceptions =
                scheduleExceptionDao.findAllByOperatorId(operatorId);

        for (org.aldo.beautycenter.data.entities.ScheduleException existing : existingExceptions) {
            LocalDate existingStart = existing.getStartDate();
            LocalDate existingEnd = existing.getEndDate() != null ? existing.getEndDate() : existing.getStartDate();

            boolean overlap =
                    (end == null && !start.isBefore(existingStart) && !start.isAfter(existingEnd)) ||
                            (end != null && !end.isBefore(existingStart) && !start.isAfter(existingEnd));

            if (overlap) return false;
        }

        return true;
    }
}
