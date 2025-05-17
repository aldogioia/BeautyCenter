package org.aldo.beautycenter.security.exception.customException;

public class WhatsAppMessageException extends RuntimeException {
    private final String message;
    public WhatsAppMessageException(String message) {
        super(message);
        this.message = message;
    }
  @Override
  public String getMessage() {
      return message;
  }
}
