package org.aldo.beautycenter.service.implemetations;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.PasswordTokenDao;
import org.aldo.beautycenter.data.dao.UserDao;
import org.aldo.beautycenter.data.entities.PasswordToken;
import org.aldo.beautycenter.data.entities.User;
import org.aldo.beautycenter.service.interfaces.EmailService;
import org.aldo.beautycenter.service.interfaces.PasswordService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class PasswordServiceImpl implements PasswordService {
    private final UserDao userDao;
    private final PasswordEncoder passwordEncoder;
    private final PasswordTokenDao passwordTokenDao;
    private final EmailService emailService;

    @Override
    public void requestChangePassword(String email) {
        //TODO
    }

    @Override
    public void changePassword(String email, String newPassword) {
        PasswordToken passwordToken = passwordTokenDao.findByToken(email);

        User user = passwordToken.getUser();
        user.setPassword(passwordEncoder.encode(newPassword));

        userDao.save(user);
    }
}
