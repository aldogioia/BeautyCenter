package org.aldo.beautycenter.service.interfaces;

import jakarta.servlet.http.HttpServletRequest;
import org.aldo.beautycenter.data.dto.responses.AuthResponseDto;
import org.aldo.beautycenter.data.dto.create.CreateCustomerDto;
import org.aldo.beautycenter.data.entities.User;

public interface AuthService {
    AuthResponseDto signIn(String phoneNumber, String password);
    String refresh(HttpServletRequest request);
    void signUp(CreateCustomerDto createCustomerDto);
    void signOut(HttpServletRequest request, String token, User user);
}
