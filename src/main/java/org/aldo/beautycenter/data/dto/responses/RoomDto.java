package org.aldo.beautycenter.data.dto.responses;

import lombok.Data;
import org.aldo.beautycenter.data.dto.summaries.SummaryServiceDto;

import java.util.List;

@Data
public class RoomDto {
    private String id;
    private String name;
    private List<SummaryServiceDto> services;
}
