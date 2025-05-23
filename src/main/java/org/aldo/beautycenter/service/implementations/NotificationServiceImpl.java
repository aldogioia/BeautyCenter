package org.aldo.beautycenter.service.implementations;


import com.google.firebase.messaging.*;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.FcmTokenDao;
import org.aldo.beautycenter.data.dto.create.CreateFcmToken;
import org.aldo.beautycenter.data.entities.Booking;
import org.aldo.beautycenter.data.entities.FcmToken;
import org.aldo.beautycenter.data.entities.User;
import org.aldo.beautycenter.service.interfaces.NotificationService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class NotificationServiceImpl implements NotificationService {
    private final FcmTokenDao fcmTokenDao;

    @Override
    public void saveToken(CreateFcmToken createFcmToken, User user) {
        Optional<FcmToken> fcmToken = fcmTokenDao.findByToken(createFcmToken.getToken());

        if (fcmToken.isPresent()) {
            FcmToken token = fcmToken.get();

            if (token.getUser().getId().equals(user.getId())) {
                token.setPlatform(createFcmToken.getPlatform());
                fcmTokenDao.save(token);
                return;
            }
            return;
        }

        FcmToken newToken = new FcmToken();
        newToken.setToken(createFcmToken.getToken());
        newToken.setUser(user);
        newToken.setPlatform(createFcmToken.getPlatform());
        fcmTokenDao.save(newToken);
    }

    @Override
    public void sendNotificationToUser(User user, String title, String body) {
        List<FcmToken> fcmTokens = fcmTokenDao.findAllByUser(user);

        fcmTokens.forEach(fcmToken -> sendNotification(fcmToken.getToken(), title, body));
    }

    public void sendNotificationBeforeDeletingBooking(List<Booking> bookings){
        bookings.forEach(booking -> {
            final String title = "Appuntamento cancellato";
            final String body = "L'appuntamento "+ booking.getService().getName() + " è stato cancellato per disservizi";

            sendNotificationToUser(
                    booking.getBookedForCustomer(),
                    title,
                    body
            );

            sendNotificationToUser(
                    booking.getOperator(),
                    title,
                    body
            );
        });
    }

    private void sendNotification(String token, String title, String body) {
        try {
            Notification notification = Notification.builder()
                    .setTitle(title)
                    .setBody(body)
                    .build();

            Message message = Message.builder()
                    .setToken(token)
                    .setNotification(notification)
                    .build();

            String response = FirebaseMessaging.getInstance().send(message);
            System.out.println("Sent: " + response);
        } catch (FirebaseMessagingException e) {
            switch (e.getMessagingErrorCode()) {
                case UNREGISTERED:
                case INVALID_ARGUMENT:
                    fcmTokenDao.deleteByToken(token);
                    break;
                default:
                    System.out.println("Errore invio notifica: " + e.getMessagingErrorCode());
            }
        }
    }
}
