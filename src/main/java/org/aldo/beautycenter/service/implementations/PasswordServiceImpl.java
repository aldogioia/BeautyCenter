package org.aldo.beautycenter.service.implementations;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.PasswordTokenDao;
import org.aldo.beautycenter.data.dao.UserDao;
import org.aldo.beautycenter.data.dto.updates.UpdatePasswordDto;
import org.aldo.beautycenter.data.entities.PasswordToken;
import org.aldo.beautycenter.data.entities.User;
import org.aldo.beautycenter.security.exception.customException.PasswordNotMatchException;
import org.aldo.beautycenter.security.exception.customException.TokenException;
import org.aldo.beautycenter.service.interfaces.PasswordService;
import org.aldo.beautycenter.service.interfaces.WhatsAppSenderService;
import org.aldo.beautycenter.utils.PasswordTokenGenerator;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;

@Service
@RequiredArgsConstructor
public class PasswordServiceImpl implements PasswordService {
    private final UserDao userDao;
    private final PasswordEncoder passwordEncoder;
    private final PasswordTokenDao passwordTokenDao;
    private final WhatsAppSenderService whatsAppSenderService;


    @Override
    public void requestChangePassword(String phoneNumber) {
        User user = userDao.findByPhoneNumber(phoneNumber)
                .orElseThrow(() -> new EntityNotFoundException("Utente non trovato"));
        passwordTokenDao.findByUser(user).ifPresent(passwordTokenDao::delete);
        sendResetPasswordMessage(user);
    }

    @Override
    public void changePassword(String token, String newPassword) {
        PasswordToken passwordToken = passwordTokenDao.findByToken(token)
                .orElseThrow(() -> new EntityNotFoundException("Token invalido"));

        if (passwordToken.getExpirationDate().before(Date.from(Instant.now()))) {
            throw new TokenException("Token invalido");
        }

        User user = passwordToken.getUser();
        user.setPassword(passwordEncoder.encode(newPassword));

        userDao.save(user);
    }

    @Override
    public void updatePassword(UpdatePasswordDto updatePasswordDto) {
        User user = userDao.findById(updatePasswordDto.getUserId())
                .orElseThrow(() -> new EntityNotFoundException("Utente non trovato"));

        if (!passwordEncoder.matches(updatePasswordDto.getOldPassword(), user.getPassword())) {
            throw new PasswordNotMatchException("La vecchia password è errata, riprovare");
        }

        user.setPassword(passwordEncoder.encode(updatePasswordDto.getNewPassword()));
        userDao.save(user);
    }

    private void sendResetPasswordMessage(User user) {
        Instant issued = Instant.now().truncatedTo(ChronoUnit.SECONDS);
        String token = PasswordTokenGenerator.generateToken();

        PasswordToken passwordToken = new PasswordToken();
        passwordToken.setToken(token);
        passwordToken.setExpirationDate(Date.from(issued.plus(10, ChronoUnit.MINUTES)));
        passwordToken.setUser(user);

        passwordTokenDao.save(passwordToken);

        whatsAppSenderService.sendTokenRecoveryPassword(user, token);
    }
}
