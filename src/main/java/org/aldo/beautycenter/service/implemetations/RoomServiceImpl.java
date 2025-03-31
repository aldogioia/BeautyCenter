package org.aldo.beautycenter.service.implemetations;

import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.RoomDao;
import org.aldo.beautycenter.data.dao.ServiceDao;
import org.aldo.beautycenter.data.dto.CreateRoomDto;
import org.aldo.beautycenter.data.dto.RoomDto;
import org.aldo.beautycenter.data.dto.SummaryServiceDto;
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
    private final ServiceDao serviceDao;
    private final ModelMapper modelMapper;

    @Override
    public List<RoomDto> getAllRooms() {
        return roomDao.findAll()
                .stream()
                .map(room -> {
                    RoomDto roomDto = modelMapper.map(room, RoomDto.class);
                    roomDto.setServices(
                            room.getServices().stream()
                                    .map(service -> modelMapper.map(service, SummaryServiceDto.class)).toList()
                    );
                    return roomDto;
                }).toList();
    }

    @Override
    @Transactional
    public void createRoom(CreateRoomDto createRoomDto) {
        Room room = modelMapper.map(createRoomDto, Room.class);
        room.setServices(serviceDao.findAllById(createRoomDto.getServices()));
        roomDao.save(room);
    }

    @Override
    public void updateRoom(UpdateRoomDto updateRoomDto) {
        Room room = roomDao.findById(updateRoomDto.getId())
                .orElseThrow(() -> new EntityNotFoundException("Stanza non trovata"));
        modelMapper.map(updateRoomDto, room);
        room.setServices(serviceDao.findAllById(updateRoomDto.getServices()));
        roomDao.save(room);
    }

    @Override
    public void deleteRoom(String roomId) {
        roomDao.deleteById(roomId);
    }
}
