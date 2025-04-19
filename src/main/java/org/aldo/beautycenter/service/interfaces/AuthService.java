package org.aldo.beautycenter.service.interfaces;

import jakarta.servlet.http.HttpServletRequest;
import org.aldo.beautycenter.data.dto.CreateCustomerDto;

import java.util.Map;

public interface AuthService {
    Map<String, String> signIn(String email, String password);
    String refresh(HttpServletRequest request);
    void signUp(CreateCustomerDto createCustomerDto);
    void signOut(HttpServletRequest request);
}
