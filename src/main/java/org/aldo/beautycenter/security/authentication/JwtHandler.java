package org.aldo.beautycenter.security.authentication;

import com.nimbusds.jose.*;
import com.nimbusds.jose.crypto.MACSigner;
import com.nimbusds.jose.crypto.MACVerifier;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.entities.User;
import org.aldo.beautycenter.data.enumerators.Token;
import org.aldo.beautycenter.security.exception.customException.TokenException;
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

    public String generateAccessToken(User user) {
        return "Bearer " + createToken(user, 15, ChronoUnit.MINUTES, Token.ACCESS);
    }

    public String generateRefreshToken(User user) {
        return createToken(user, 365, ChronoUnit.DAYS, Token.REFRESH);
    }

    private String createToken(User user, long amountToAdd, ChronoUnit unit, Token type) {
        Instant issuedAt = Instant.now().truncatedTo(ChronoUnit.SECONDS);

        JWTClaimsSet claims = new JWTClaimsSet.Builder()
                .subject(user.getPhoneNumber())
                .issueTime(Date.from(issuedAt))
                .expirationTime(Date.from(issuedAt.plus(amountToAdd, unit)))
                .claim("role", user.getRole().name())
                .claim("type", type)
                .build();

        try {
            SignedJWT signedJWT = new SignedJWT(new JWSHeader(JWSAlgorithm.HS256), claims);
            signedJWT.sign(new MACSigner(secret.getBytes()));
            return signedJWT.serialize();
        } catch (Exception e) {
            throw new TokenException("Errore durante la generazione del " + type.name().toLowerCase() + " token");
        }
    }

    public boolean isValidAccessToken(String token) {
        return isValidToken(token, Token.ACCESS);
    }

    public boolean isValidRefreshToken(String token) {
        return isValidToken(token, Token.REFRESH);
    }

    private boolean isValidToken(String token, Token expectedType) {
        try {
            SignedJWT signedJWT = SignedJWT.parse(token);
            if (!signedJWT.verify(new MACVerifier(secret.getBytes()))) return false;

            JWTClaimsSet claims = signedJWT.getJWTClaimsSet();
            Date expiration = claims.getExpirationTime();
            String type = claims.getStringClaim("type");

            if (expiration == null) return false;
            return expectedType.name().equals(type) && expiration.after(new Date());
        } catch (Exception e) {
            return false;
        }
    }

    public String getJwtFromRequest(HttpServletRequest request, Token token) {
        String starts = "";
        String header = "";

        if (token == Token.ACCESS ) {
            header = request.getHeader(HttpHeaders.AUTHORIZATION);
            starts = "Bearer ";
        }
        else if (token == Token.REFRESH) {
            header = request.getHeader("X-Refresh-Token");
        }

        if (header != null && header.startsWith(starts)) {
            return header.replace(starts, "");
        }

        return "invalid";
    }

    public String getPhoneNumberFromToken(String token) {
        try {
            SignedJWT signedJWT = SignedJWT.parse(token);
            return signedJWT.getJWTClaimsSet().getSubject();
        } catch (Exception e) {
            throw new TokenException("Token non valido");
        }
    }

    public static Date getExpirationTime(String token) {
        try {
            SignedJWT signedJWT = SignedJWT.parse(token);
            return signedJWT.getJWTClaimsSet().getExpirationTime();
        } catch (Exception e) {
            throw new TokenException("Token non valido");
        }
    }
}
