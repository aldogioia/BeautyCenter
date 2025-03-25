package org.aldo.beautycenter.service.implemetations;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.RoomDao;
import org.aldo.beautycenter.data.dto.CreateRoomDto;
import org.aldo.beautycenter.data.dto.RoomDto;
import org.aldo.beautycenter.data.dto.UpdateRoomDto;
import org.aldo.beautycenter.data.entities.Room;
import org.aldo.beautycenter.service.interfaces.RoomService;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RoomServiceImpl implements RoomService {
    private final RoomDao roomDao;
    private final ModelMapper modelMapper;

    @Override
    public List<RoomDto> getAllRooms(String roomId) {
        return roomDao.findAll().stream()
                .map(room -> modelMapper.map(room, RoomDto.class))
                .toList();
    }

    @Override
    public void createRoom(CreateRoomDto createRoomDto) {
        roomDao.save(
                modelMapper.map(createRoomDto, Room.class)
        );
    }

    @Override
    public void updateRoom(UpdateRoomDto updateRoomDto) {
        roomDao.save(
                modelMapper.map(updateRoomDto, Room.class)
        );
    }

    @Override
    public void deleteRoom(String roomId) {
        roomDao.deleteById(roomId);
    }
}
