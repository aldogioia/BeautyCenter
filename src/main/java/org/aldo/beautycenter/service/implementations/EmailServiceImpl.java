package org.aldo.beautycenter.service.implementations;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.service.interfaces.EmailService;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EmailServiceImpl implements EmailService {
    private final JavaMailSender javaMailSender;

    @Override
    public void sendEmail(String name, String surname, String email, String token) throws MessagingException {
        MimeMessage message = javaMailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, false);

        String textContent = "Ciao " + name + " " + surname + ",\n\n" +
                "Abbiamo ricevuto una richiesta per reimpostare la tua password.\n" +
                "Questo e il codice di verifica: "+ token + "\n\n" +
                "Se non hai richiesto questa operazione, ignora questa email.\n\n" +
                "Grazie";

        helper.setTo(email);
        helper.setSubject("Reset Password");
        helper.setText(textContent, false);
        javaMailSender.send(message);
    }
}
