package org.aldo.beautycenter.data.dao;

import org.aldo.beautycenter.data.entities.Room;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RoomDao extends JpaRepository<Room, String> {
}
