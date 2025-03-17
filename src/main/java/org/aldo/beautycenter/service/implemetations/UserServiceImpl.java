package org.aldo.beautycenter.service.implemetations;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.UserDao;
import org.aldo.beautycenter.data.dto.UpdateUserDto;
import org.aldo.beautycenter.data.entities.User;
import org.aldo.beautycenter.service.interfaces.UserService;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final UserDao userDao;
    public void updateUser(UpdateUserDto updateUserDto) {
        User user = userDao.findById(updateUserDto.getId())
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setEmail(updateUserDto.getEmail());
        user.setPhoneNumber(updateUserDto.getPhoneNumber());

        userDao.save(user);
    }

    public void deleteUser(String Id) {
        userDao.deleteById(Id);
    }
}
