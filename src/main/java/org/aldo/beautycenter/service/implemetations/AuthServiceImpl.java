package org.aldo.beautycenter.service.implemetations;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.CreateUserDto;
import org.aldo.beautycenter.security.authentication.JwtHandler;
import org.aldo.beautycenter.service.interfaces.AuthService;
import org.aldo.beautycenter.service.interfaces.UserService;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {
    private final JwtHandler jwtHandler;
    private final UserService userService;
    private final AuthenticationManager authenticationManager;
    @Override
    public String login(String email, String password) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(email, password));

        return jwtHandler.generateToken(userService.getUserByEmail(email));
    }

    @Override
    public void register(CreateUserDto createUserDto) {
        userService.createUser(createUserDto);
    }

    @Override
    public void logout(HttpServletRequest request) {
        //TODO
    }
}
