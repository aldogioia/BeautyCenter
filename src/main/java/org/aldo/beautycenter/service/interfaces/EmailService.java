package org.aldo.beautycenter.service.interfaces;

import jakarta.mail.MessagingException;

public interface EmailService {
    void sendEmail(String name, String surname, String email, String resetLink) throws MessagingException;
}
