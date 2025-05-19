package org.aldo.beautycenter.security.exception.customException;

public class PhoneNumberConflictException extends RuntimeException {
    private final String message;
    public PhoneNumberConflictException(String message) {
        super(message);
        this.message = message;
    }
    @Override
    public String getMessage() {
        return message;
    }
}
