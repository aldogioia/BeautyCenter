package org.aldo.beautycenter.security.exception.customException;

public class BookingGuestException extends RuntimeException {
    private final String message;
    public BookingGuestException(String message){
        super(message);
        this.message = message;
    }
    @Override
    public String getMessage() {
        return message;
    }
}