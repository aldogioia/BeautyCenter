package org.aldo.beautycenter.security.exception.customException;

public class S3DeleteException  extends RuntimeException {
    private final String message;

    public S3DeleteException(String message){
        this.message = message;
    }

    @Override
    public String getMessage(){
        return message;
    }
}
