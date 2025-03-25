package org.aldo.beautycenter.data.dto;

import org.aldo.beautycenter.security.customAnnotation.ValidServiceId;

import java.util.List;

public class UpdateRoomDto {
//    @ValidRoomId
    private String roomId;
    private List<@ValidServiceId String> services;
}
