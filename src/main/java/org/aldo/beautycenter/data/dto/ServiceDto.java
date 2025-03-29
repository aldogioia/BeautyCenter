package org.aldo.beautycenter.data.dto;

import lombok.Data;

@Data
public  class ServiceDto {
    private String id;
    private String imgUrl;
    private String name;
    private Double price;
    private Double duration;
}
