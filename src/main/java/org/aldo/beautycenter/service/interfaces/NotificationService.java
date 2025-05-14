package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.create.CreateFcmToken;
import org.aldo.beautycenter.data.entities.Booking;
import org.aldo.beautycenter.data.entities.User;

import java.util.List;

public interface NotificationService {
    void saveToken(CreateFcmToken createFcmToken, User user);
    void sendNotificationToUser(User user, String title, String body);
    void sendNotificationBeforeDeletingBooking(List<Booking> bookings);
}
