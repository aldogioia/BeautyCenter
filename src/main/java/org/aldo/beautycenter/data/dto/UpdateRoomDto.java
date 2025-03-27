package org.aldo.beautycenter.data.dto;

import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidRoomId;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidServiceId;

import java.util.List;

@Data
public class UpdateRoomDto {
    @ValidRoomId
    private String roomId;

    private List<@ValidServiceId String> services;
}
