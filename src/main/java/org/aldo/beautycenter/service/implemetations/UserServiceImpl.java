package org.aldo.beautycenter.service.implemetations;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.UserDao;
import org.aldo.beautycenter.data.dto.CreateUserDto;
import org.aldo.beautycenter.data.dto.UpdateUserDto;
import org.aldo.beautycenter.data.entities.User;
import org.aldo.beautycenter.service.interfaces.UserService;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final UserDao userDao;
    private final ModelMapper modelMapper;

    @Override
    public void createUser(CreateUserDto createUserDto) {
        User user = modelMapper.map(createUserDto, User.class);
        userDao.save(user);
    }

    @Override
    public User getUserByEmail(String email) {
        return userDao.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

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
