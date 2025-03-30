package org.aldo.beautycenter.security.exception.customException;

public class EmailAlreadyUsed extends RuntimeException {
    private final String message;
    public EmailAlreadyUsed(String message){
        super(message);
        this.message = message;
    }
    @Override
    public String getMessage() {
        return message;
    }
}
