package org.aldo.beautycenter.security.exception.customException;

public class NumberAlreadyUsed extends RuntimeException {
    private final String message;
    public NumberAlreadyUsed(String message){
        super(message);
        this.message = message;
    }
    @Override
    public String getMessage() {
        return message;
    }
}
