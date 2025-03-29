package org.aldo.beautycenter.security.exception.customException;

public class S3PutException extends RuntimeException {
    private final String message;

    public S3PutException(String message){
        this.message = message;
    }

    @Override
    public String getMessage(){
        return message;
    }
}
