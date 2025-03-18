package org.aldo.beautycenter.service.interfaces;

import jakarta.servlet.http.HttpServletRequest;
import org.aldo.beautycenter.data.dto.CreateCustomerDto;

public interface AuthService {
    String login(String email, String password);
    void register(CreateCustomerDto createCustomerDto);
    void logout(HttpServletRequest request);
}
