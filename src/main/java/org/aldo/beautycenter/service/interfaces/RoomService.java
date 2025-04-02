package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.CreateRoomDto;
import org.aldo.beautycenter.data.dto.RoomDto;
import org.aldo.beautycenter.data.dto.UpdateRoomDto;

import java.util.List;

public interface RoomService {
    List<RoomDto> getAllRooms();

    RoomDto createRoom(CreateRoomDto createRoomDto);

    void updateRoom(UpdateRoomDto updateRoomDto);

    void deleteRoom(String roomId);
}
