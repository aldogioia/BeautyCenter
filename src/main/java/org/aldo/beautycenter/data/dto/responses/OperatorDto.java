package org.aldo.beautycenter.data.dto.responses;

import lombok.Data;
import org.aldo.beautycenter.data.dto.summaries.SummaryServiceDto;

import java.util.List;

@Data
public class OperatorDto {
    private String id;
    private String name;
    private String surname;
    private String phoneNumber;
    private String imgUrl;
    private List<SummaryServiceDto> services;
}
