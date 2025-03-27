package org.aldo.beautycenter.security.exception.customException;

public class EmailNotSentException extends RuntimeException {
    private final String message;
    public EmailNotSentException(String message){
        super(message);
        this.message = message;
    }
    @Override
    public String getMessage() {
        return message;
    }
}
