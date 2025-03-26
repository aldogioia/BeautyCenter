package org.aldo.beautycenter.utils;

import org.springframework.stereotype.Component;

import java.math.BigInteger;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;

@Component
public class PasswordTokenGenerator {
    private static final SecureRandom random = new SecureRandom();

    public static String generateToken() {
        String token = new BigInteger(130, random).toString(32);
        return URLEncoder.encode(token, StandardCharsets.UTF_8);
    }
}
