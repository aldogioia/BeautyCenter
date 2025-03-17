package org.aldo.beautycenter.service.interfaces;

import jakarta.servlet.http.HttpServletRequest;
import org.aldo.beautycenter.data.dto.CreateUserDto;

public interface AuthService {
    String login(String email, String password);
    void register(CreateUserDto createUserDto);
    void logout(HttpServletRequest request);
}
