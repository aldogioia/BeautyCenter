package org.aldo.beautycenter.service.implemetations;

import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.RoomDao;
import org.aldo.beautycenter.data.dto.create.CreateRoomDto;
import org.aldo.beautycenter.data.dto.responses.RoomDto;
import org.aldo.beautycenter.data.dto.updates.UpdateRoomDto;
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
    public List<RoomDto> getAllRooms() {
        return roomDao.findAll()
                .stream()
                .map(room -> modelMapper.map(room, RoomDto.class))
                .toList();
    }

    @Override
    @Transactional
    public RoomDto createRoom(CreateRoomDto createRoomDto) {
        Room room = modelMapper.map(createRoomDto, Room.class);
        roomDao.save(room);

        return modelMapper.map(room, RoomDto.class);
    }

    @Override
    @Transactional
    public void updateRoom(UpdateRoomDto updateRoomDto) {
        Room room = roomDao.findById(updateRoomDto.getId())
                .orElseThrow(() -> new EntityNotFoundException("Stanza non trovata"));
        modelMapper.map(updateRoomDto, room);
        roomDao.save(room);
    }

    @Override
    public void deleteRoom(String roomId) {
        roomDao.deleteById(roomId);
    }
}
