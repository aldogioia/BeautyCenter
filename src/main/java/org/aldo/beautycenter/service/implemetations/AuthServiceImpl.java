package org.aldo.beautycenter.service.implemetations;

import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.UserDao;
import org.aldo.beautycenter.data.dto.CreateCustomerDto;
import org.aldo.beautycenter.security.authentication.JwtHandler;
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
    private final AuthenticationManager authenticationManager;
    @Override
    public String signIn(String email, String password) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(email, password));

        return jwtHandler.generateToken(userDao.findByEmail(email)
                .orElseThrow(() -> new EntityNotFoundException("Utente non trovato")));
    }

    @Override
    public void signUp(CreateCustomerDto createCustomerDto) {
        customerService.createCustomer(createCustomerDto);
    }

    @Override
    public void signOut(HttpServletRequest request) {
        blacklistService.addTokenToBlacklist(jwtHandler.getJwtFromRequest(request));
    }
}
