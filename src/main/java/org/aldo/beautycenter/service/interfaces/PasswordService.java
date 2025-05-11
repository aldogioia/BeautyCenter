package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.updates.UpdatePasswordDto;

public interface PasswordService {
    void requestChangePassword(String email);
    void changePassword(String email, String newPassword);
    void updatePassword(UpdatePasswordDto updatePasswordDto);
}
