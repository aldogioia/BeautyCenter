package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.CreateUserDto;
import org.aldo.beautycenter.data.dto.UpdateUserDto;
import org.aldo.beautycenter.data.entities.User;

public interface UserService {
    void createUser(CreateUserDto createUserDto);
    User getUserByEmail(String email);
    void updateUser(UpdateUserDto updateUserDto);
    void deleteUser(String Id);
}
