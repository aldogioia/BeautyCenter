package org.aldo.beautycenter.service.implemetations;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.PasswordTokenDao;
import org.aldo.beautycenter.data.dao.UserDao;
import org.aldo.beautycenter.data.entities.PasswordToken;
import org.aldo.beautycenter.data.entities.User;
import org.aldo.beautycenter.security.exception.customException.EmailNotSentException;
import org.aldo.beautycenter.security.exception.customException.TokenException;
import org.aldo.beautycenter.service.interfaces.EmailService;
import org.aldo.beautycenter.service.interfaces.PasswordService;
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
    private final EmailService emailService;

    @Override
    public void requestChangePassword(String email) {
        User user = userDao.findByEmail(email)
                .orElseThrow(() -> new EntityNotFoundException("Utente non trovato"));
        passwordTokenDao.findByUser(user).ifPresent(passwordTokenDao::delete);
        sendResetPasswordEmail(user);
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

    private void sendResetPasswordEmail(User user) {
        Instant issued = Instant.now().truncatedTo(ChronoUnit.SECONDS);
        String token = PasswordTokenGenerator.generateToken();

        PasswordToken passwordToken = new PasswordToken();
        passwordToken.setToken(token);
        passwordToken.setExpirationDate(Date.from(issued.plus(10, ChronoUnit.MINUTES)));
        passwordToken.setUser(user);

        passwordTokenDao.save(passwordToken);

        try {
            emailService.sendEmail(
                    user.getName(),
                    user.getSurname(),
                    user.getEmail(),
                    token
            );
        } catch (Exception e) {
            throw new EmailNotSentException("Error while sending email");
        }
    }
}
