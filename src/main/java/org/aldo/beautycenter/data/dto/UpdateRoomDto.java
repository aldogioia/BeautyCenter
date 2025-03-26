package org.aldo.beautycenter.data.dto;

import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.ValidRoomId;
import org.aldo.beautycenter.security.customAnnotation.ValidServiceId;

import java.util.List;

@Data
public class UpdateRoomDto {
    @ValidRoomId
    private String roomId;

    private List<@ValidServiceId String> services;
}
