package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.UpdateUserDto;

public interface UserService {
    void updateUser(UpdateUserDto updateUserDto);
    void deleteUser(String Id);
}
