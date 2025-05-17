package org.aldo.beautycenter.service.implementations;

import org.aldo.beautycenter.data.entities.Booking;
import org.aldo.beautycenter.data.entities.User;
import org.aldo.beautycenter.security.exception.customException.BookingGuestException;
import org.aldo.beautycenter.security.exception.customException.WhatsAppMessageException;
import org.aldo.beautycenter.service.interfaces.WhatsAppSenderService;
import org.aldo.beautycenter.utils.Constants;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class WhatsAppSenderServiceImpl implements WhatsAppSenderService {
    @Value("${whatsapp.access.token}")
    private String accessToken;

    @Value("${whatsapp.phone.number.id}")
    private String phoneNumberId;

    private final RestTemplate restTemplate = new RestTemplate();


    @Override
    public void sendTokenRecoveryPassword(User user, String token) {
        sendMessage(user.getPhoneNumber(), Constants.TEMPLATE_RECOVERY_PASSWORD, List.of()); //TODO inserire i parametri adeguati
    }

    @Override
    public void sendConfirmationBooking(Booking booking) {
        final String number = booking.getBookedForNumber();
        if (number != null)
            sendMessage(number, Constants.TEMPLATE_CONFIRMATION_BOOKING, List.of()); //TODO inserire i parametri adeguati
        else
            throw new BookingGuestException("Il numero di telefono non è valido");
    }

    @Override
    public void sendReminderBooking(Booking booking) {
        final String number = booking.getBookedForNumber();
        if (number != null)
            sendMessage(number, Constants.TEMPLATE_REMINDER_BOOKING, List.of()); //TODO inserire i parametri adeguati
        else
            throw new BookingGuestException("Il numero di telefono non è valido");
    }

    @Override
    public void sendCancelBooking(Booking booking) {
        final String number = booking.getBookedForNumber();
        if (number != null)
            sendMessage(number, Constants.TEMPLATE_CANCEL_BOOKING, List.of()); //TODO inserire i parametri adeguati
        else
            throw new BookingGuestException("Il numero di telefono non è valido");
    }

    private void sendMessage(String recipientPhone, String templateName, List<String> parameters) {
        String url = Constants.WHATSAPP_API_URL + phoneNumberId + Constants.WHATSAPP_MESSAGE_END_POINT;

        //Preparo gli headers per la chiamata Rest
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);
        headers.setContentType(MediaType.APPLICATION_JSON);

        //Preparo il template e lo inserisco nel body
        Map<String, Object> template = new HashMap<>();
        template.put("name", templateName);
        template.put("language", Map.of("code", "it")); //TODO verificare che it vada bene

        if (!parameters.isEmpty()) {
            List<Map<String, Object>> components = new ArrayList<>();
            Map<String, Object> body = new HashMap<>();
            body.put("type", "body");
            List<Map<String, String>> paramList = parameters.stream()
                    .map(p -> Map.of("type", "text", "text", p))
                    .collect(Collectors.toList());
            body.put("parameters", paramList);
            components.add(body);
            template.put("components", components);
        }

        //Preparo il body per la chiamata Rest
        Map<String, Object> body = new HashMap<>();
        body.put("messaging_product", "whatsapp");
        body.put("to", recipientPhone.length() == 10 ? "39" + recipientPhone :  recipientPhone);
        body.put("type", "template");
        body.put("template", template);

        try{
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);
            ResponseEntity<String> response = restTemplate.postForEntity(url, entity, String.class);
            System.out.println(response.getBody());
        } catch (Exception e) {
            throw new WhatsAppMessageException("Errore durante l'invio del messaggio su WhatsApp");
        }

    }
}
