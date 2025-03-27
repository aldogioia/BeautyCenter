package org.aldo.beautycenter.security.exception.customException;

public class TokenException extends RuntimeException{
    private final String message;
    public TokenException(String message){
        super(message);
        this.message = message;
    }
    @Override
    public String getMessage() {
        return message;
    }
}
