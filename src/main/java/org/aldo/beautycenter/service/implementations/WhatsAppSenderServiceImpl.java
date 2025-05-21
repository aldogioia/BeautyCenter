package org.aldo.beautycenter.service.implementations;

import org.aldo.beautycenter.data.entities.Booking;
import org.aldo.beautycenter.data.entities.User;
import org.aldo.beautycenter.data.enumerators.TemplateType;
import org.aldo.beautycenter.security.exception.customException.WhatsAppMessageException;
import org.aldo.beautycenter.service.interfaces.WhatsAppSenderService;
import org.aldo.beautycenter.utils.Constants;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.format.DateTimeFormatter;
import java.util.*;
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
        List<String> parameters = List.of(token);
        sendMessage(
                user.getPhoneNumber(),
                Constants.TEMPLATE_RECOVERY_PASSWORD,
                parameters,
                TemplateType.AUTHENTICATION
        );
    }

    @Override
    public void sendConfirmationBooking(Booking booking) {
        String number = checkGuestNumber(booking);

        List<String> parameters = List.of(
                booking.getBookedForName(),
                booking.getService().getName(),
                booking.getDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")),
                booking.getTime().format(DateTimeFormatter.ofPattern("HH:mm"))
        );

        sendMessage(
                number,
                Constants.TEMPLATE_CONFIRMATION_BOOKING,
                parameters,
                TemplateType.UTILITY
        );
    }

    @Override
    public void sendReminderBooking(Booking booking) {
        String number = checkGuestNumber(booking);

        List<String> parameters = List.of(
                booking.getBookedForName(),
                booking.getService().getName(),
                booking.getDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")),
                booking.getTime().format(DateTimeFormatter.ofPattern("HH:mm"))
        );

        sendMessage(
                number,
                Constants.TEMPLATE_REMINDER_BOOKING,
                parameters,
                TemplateType.UTILITY
        );
    }

    @Override
    public void sendCancelBooking(Booking booking) {
        String number = checkGuestNumber(booking);

        List<String> parameters = List.of(
                booking.getBookedForName(),
                booking.getService().getName(),
                booking.getDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")),
                booking.getTime().format(DateTimeFormatter.ofPattern("HH:mm"))
        );

        sendMessage(
                number,
                Constants.TEMPLATE_CANCEL_BOOKING,
                parameters,
                TemplateType.UTILITY
        );
    }

    private void sendMessage(String recipientPhone, String templateName, List<String> parameters, TemplateType templateType) {
        String url = Constants.WHATSAPP_API_URL + phoneNumberId + Constants.WHATSAPP_MESSAGE_END_POINT;

        // Headers
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);
        headers.setContentType(MediaType.APPLICATION_JSON);

        Map<String, Object> template = new HashMap<>();
        template.put("name", templateName);
        template.put("language", Map.of("code", "it"));

        List<Map<String, Object>> components = new ArrayList<>();

        if (!parameters.isEmpty()) {
            Map<String, Object> bodyComponent = new HashMap<>();
            bodyComponent.put("type", "body");

            List<Map<String, String>> paramList = parameters.stream()
                    .map(p -> Map.of("type", "text", "text", p))
                    .collect(Collectors.toList());

            bodyComponent.put("parameters", paramList);
            components.add(bodyComponent);
        }


        if (templateType == TemplateType.AUTHENTICATION) {
            Map<String, Object> footerComponent = new HashMap<>();
            footerComponent.put("type", "footer");
            components.add(footerComponent);
        }

        if (templateType.name().equals(TemplateType.AUTHENTICATION.name()) && !parameters.isEmpty()) {
            Map<String, Object> buttonComponent = new HashMap<>();
            buttonComponent.put("type", "button");
            buttonComponent.put("sub_type", "url");
            buttonComponent.put("index", "0");

            Map<String, Object> buttonParam = new HashMap<>();
            buttonParam.put("type", "text");
            buttonParam.put("text", parameters.get(0));

            buttonComponent.put("parameters", List.of(buttonParam));
            components.add(buttonComponent);
        }

        template.put("components", components);

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("messaging_product", "whatsapp");
        requestBody.put("to", normalizePhoneNumber(recipientPhone));
        requestBody.put("type", "template");
        requestBody.put("template", template);

        try {
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
            ResponseEntity<String> response = restTemplate.postForEntity(url, entity, String.class);
            System.out.println("WhatsApp API response: " + response.getBody());
            if (!response.getStatusCode().is2xxSuccessful()) {
                throw new WhatsAppMessageException("Errore durante l'invio del messaggio su WhatsApp");
            }
        } catch (Exception e) {
            System.out.println("WhatsApp API error: " + e.getMessage());
            throw new WhatsAppMessageException("Errore durante l'invio del messaggio su WhatsApp");
        }
    }


    private String checkGuestNumber(Booking booking) {
        String number = booking.getBookedForNumber();
        if (number == null)
            throw new WhatsAppMessageException("Errore durante l'invio del messaggio su WhatsApp, numero destinatario non valido");
        else return number;
    }

    private String normalizePhoneNumber(String phone) {
        if (phone.startsWith("39") || phone.length() > 10) return phone;
        return "39" + phone;
    }
}
