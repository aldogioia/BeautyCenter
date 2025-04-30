package org.aldo.beautycenter.service.interfaces;

import jakarta.servlet.http.HttpServletRequest;
import org.aldo.beautycenter.data.dto.AuthResponseDto;
import org.aldo.beautycenter.data.dto.CreateCustomerDto;

public interface AuthService {
    AuthResponseDto signIn(String email, String password);
    String refresh(HttpServletRequest request);
    void signUp(CreateCustomerDto createCustomerDto);
    void signOut(HttpServletRequest request);
}
