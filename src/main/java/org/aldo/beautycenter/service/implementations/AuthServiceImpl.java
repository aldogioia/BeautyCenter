package org.aldo.beautycenter.service.implementations;

import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.FcmTokenDao;
import org.aldo.beautycenter.data.dao.UserDao;
import org.aldo.beautycenter.data.dto.responses.AuthResponseDto;
import org.aldo.beautycenter.data.dto.create.CreateCustomerDto;
import org.aldo.beautycenter.data.entities.User;
import org.aldo.beautycenter.data.enumerators.Token;
import org.aldo.beautycenter.security.authentication.JwtHandler;
import org.aldo.beautycenter.security.exception.customException.TokenException;
import org.aldo.beautycenter.service.interfaces.AuthService;
import org.aldo.beautycenter.service.interfaces.BlacklistService;
import org.aldo.beautycenter.service.interfaces.CustomerService;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {
    private final JwtHandler jwtHandler;
    private final UserDao userDao;
    private final BlacklistService blacklistService;
    private final CustomerService customerService;
    private final FcmTokenDao fcmTokenDao;
    private final AuthenticationManager authenticationManager;

    @Override
    public AuthResponseDto signIn(String phoneNumber, String password) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(phoneNumber, password));

        User user = userDao.findByPhoneNumber(phoneNumber)
                .orElseThrow(() -> new EntityNotFoundException("Utente non trovato"));

        AuthResponseDto authResponseDto = new AuthResponseDto();

        authResponseDto.setAccessToken(jwtHandler.generateAccessToken(user));
        authResponseDto.setRefreshToken(jwtHandler.generateRefreshToken(user));
        authResponseDto.setUserId(user.getId());

        return authResponseDto;
    }

    @Override
    public String refresh(HttpServletRequest request) {
        String refreshToken = jwtHandler.getJwtFromRequest(request, Token.REFRESH);

        if (blacklistService.isTokenBlacklisted(refreshToken)) {
            throw new TokenException("Refresh token fornito già revocato");
        }

        if (!jwtHandler.isValidRefreshToken(refreshToken)) {
            throw new TokenException("Refresh token non valido o scaduto");
        }

        try {
            String phoneNumber = jwtHandler.getPhoneNumberFromToken(refreshToken);
            var user = userDao.findByPhoneNumber(phoneNumber)
                    .orElseThrow(() -> new EntityNotFoundException("Utente non trovato"));

            return jwtHandler.generateAccessToken(user);
        }
        catch (Exception e) {
            throw new TokenException("Errore durante il refresh del token");
        }
    }

    @Override
    public void signUp(CreateCustomerDto createCustomerDto) {
        customerService.createCustomer(createCustomerDto);
    }

    @Override
    @Transactional
    public void signOut(HttpServletRequest request, String token, User user) {

        //TODO
        /*user.getTokens().stream()
                .filter(fcmToken -> fcmToken.getToken().equals(token))
                .forEach(fcmToken -> fcmTokenDao.deleteByToken(token));*/

        blacklistService.addTokenToBlacklist(jwtHandler.getJwtFromRequest(request, Token.ACCESS));
        blacklistService.addTokenToBlacklist(jwtHandler.getJwtFromRequest(request, Token.REFRESH));
    }
}
