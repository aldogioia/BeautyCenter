package org.aldo.beautycenter.security.exception.customException;

public class PasswordNotMatchException extends RuntimeException {
    private final String message;
    public PasswordNotMatchException(String message) {
        super(message);
        this.message = message;
    }

    @Override
    public String getMessage() {
        return message;
    }
}
