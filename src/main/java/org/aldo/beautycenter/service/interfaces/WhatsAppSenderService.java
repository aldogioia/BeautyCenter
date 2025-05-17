package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.entities.Booking;
import org.aldo.beautycenter.data.entities.User;

public interface WhatsAppSenderService {
    void sendTokenRecoveryPassword(User user, String token);
    void sendConfirmationBooking(Booking booking);
    void sendReminderBooking(Booking booking);
    void sendCancelBooking(Booking booking);
}
