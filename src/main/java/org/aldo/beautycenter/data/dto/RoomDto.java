package org.aldo.beautycenter.data.dto;

import lombok.Data;

import java.util.List;

@Data
public class RoomDto {
    private String id;
    private String name;
    private List<SummaryServiceDto> services;
}
