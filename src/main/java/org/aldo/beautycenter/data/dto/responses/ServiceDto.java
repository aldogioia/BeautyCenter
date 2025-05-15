package org.aldo.beautycenter.data.dto.responses;

import lombok.Data;
import org.aldo.beautycenter.data.dto.summaries.SummaryToolDto;

import java.util.List;

@Data
public  class ServiceDto {
    private String id;
    private String imgUrl;
    private String name;
    private Double price;
    private Long duration;
    private List<SummaryToolDto> tools;
}
