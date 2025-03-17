package org.aldo.beautycenter.security.authentication;

import com.nimbusds.jose.*;
import com.nimbusds.jose.crypto.MACSigner;
import com.nimbusds.jose.crypto.MACVerifier;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.entities.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Component;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;

@Component
@RequiredArgsConstructor
public class JwtHandler {
    @Value("${jwt.secret}")
    private String secret;

    public String generateToken(User user) {
        Instant issuedAt = Instant.now().truncatedTo(ChronoUnit.SECONDS);

        JWTClaimsSet claims = new JWTClaimsSet.Builder()
                .subject(user.getEmail())
                .issueTime(Date.from(issuedAt))
                .expirationTime(Date.from(issuedAt.plus(24, ChronoUnit.HOURS))) //todo change
                .build();

        Payload payload = new Payload(claims.toJSONObject());
        JWSObject jwsObject = new JWSObject(new JWSHeader(JWSAlgorithm.HS256), payload);

        try {
            jwsObject.sign(new MACSigner(secret.getBytes()));
        } catch (Exception e) {
            throw new RuntimeException("Error while generating token", e);
        }

        return jwsObject.serialize();
    }

    public boolean isValidToken(String token) {
        try {
            SignedJWT signedJWT = SignedJWT.parse(token);
            JWSVerifier verifier = new MACVerifier(secret.getBytes());
            if (!signedJWT.verify(verifier)) {
                return false;
            }
            Date expiration = signedJWT.getJWTClaimsSet().getExpirationTime();
            return expiration == null || !expiration.before(new Date());
        } catch (Exception e) {
            return false;
        }
    }

    public String getJwtFromRequest(HttpServletRequest request) {
        String header = request.getHeader(HttpHeaders.AUTHORIZATION);
        if (header != null && header.startsWith("Bearer ")) {
            return header.replace("Bearer ", "");
        }
        return "invalid";
    }

    public String getEmailFromToken(String token) {
        try {
            SignedJWT signedJWT = SignedJWT.parse(token);
            return signedJWT.getJWTClaimsSet().getSubject();
        } catch (Exception e) {
            throw new RuntimeException("Invalid token");
        }
    }

    public Date getExpirationDateFromToken(String token) {
        try {
            SignedJWT signedJWT = SignedJWT.parse(token);
            return signedJWT.getJWTClaimsSet().getExpirationTime();
        } catch (Exception e) {
            throw new RuntimeException("Invalid token");
        }
    }
}
