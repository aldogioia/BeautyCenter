package org.aldo.beautycenter.security.exception.customException;

public class TokenExpiredException extends RuntimeException{
    private final String message;

    public TokenExpiredException(String message) {
        super(message);
        this.message = message;
    }

    @Override
    public String getMessage() {
        return message;
    }
    }
