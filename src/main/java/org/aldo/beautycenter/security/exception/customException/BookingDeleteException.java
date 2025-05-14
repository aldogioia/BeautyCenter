package org.aldo.beautycenter.security.exception.customException;

public class BookingDeleteException extends RuntimeException {
    private final String message;
    public BookingDeleteException(String message) {
        super(message);
        this.message = message;
    }
    @Override
    public String getMessage() {
        return message;
    }
}
