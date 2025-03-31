package org.aldo.beautycenter.security.exception.customException;

public class BookingConflictException extends RuntimeException {
    private final String message;
    public BookingConflictException(String message){
        super(message);
        this.message = message;
    }
    @Override
    public String getMessage() {
        return message;
    }
}
