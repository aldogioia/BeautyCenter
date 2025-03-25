package org.aldo.beautycenter.service.interfaces;

public interface PasswordService {
    void requestChangePassword(String email);
    void changePassword(String email, String newPassword);
}
