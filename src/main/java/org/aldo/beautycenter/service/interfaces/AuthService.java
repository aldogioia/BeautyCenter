package org.aldo.beautycenter.service.interfaces;

import jakarta.servlet.http.HttpServletRequest;
import org.aldo.beautycenter.data.dto.CreateCustomerDto;

public interface AuthService {
    String signIn(String email, String password);
    void signUp(CreateCustomerDto createCustomerDto);
    void signOut(HttpServletRequest request);
}
