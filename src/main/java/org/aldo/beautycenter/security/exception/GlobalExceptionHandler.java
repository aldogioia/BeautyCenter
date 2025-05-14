package org.aldo.beautycenter.security.exception;

import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import org.aldo.beautycenter.data.dto.responses.ErrorDto;
import org.aldo.beautycenter.security.exception.customException.*;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;

import java.util.Date;

@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ErrorDto onException(WebRequest req, Exception e) {
        return createErrorResponse(req, e.getMessage());
    }

    @ExceptionHandler(EntityNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ErrorDto onEntityNotFoundException(WebRequest req, EntityNotFoundException e) {
        return createErrorResponse(req, e.getMessage());
    }

    @ExceptionHandler(EmailNotSentException.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ErrorDto onEmailNotSentException(WebRequest req, EmailNotSentException e) {
        return createErrorResponse(req, e.getMessage());
    }

    @ExceptionHandler(TokenException.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ErrorDto onValidatorException(WebRequest req, TokenException e) {
        return createErrorResponse(req, e.getMessage());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ErrorDto onMethodArgumentNotValidException(WebRequest req, MethodArgumentNotValidException e) {
        return createErrorResponse(req, e.getMessage());
    }

    @ExceptionHandler(AccessDeniedException.class)
    @ResponseStatus(HttpStatus.FORBIDDEN)
    public ErrorDto onAccessDeniedException(WebRequest req, AccessDeniedException e) {
        return createErrorResponse(req, e.getMessage());
    }

    @ExceptionHandler(EmailAlreadyUsed.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ErrorDto onEmailAlreadyUsedException(WebRequest req, EmailAlreadyUsed e) {
        return createErrorResponse(req, e.getMessage());
    }

    @ExceptionHandler(TokenExpiredException.class)
    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    public ErrorDto onTokenExpiredException(WebRequest req, TokenExpiredException e) {
        return createErrorResponse(req, e.getMessage());
    }

    @ExceptionHandler(BookingConflictException.class)
    @ResponseStatus(HttpStatus.CONFLICT)
    public ErrorDto onBookingConflictException(WebRequest req, BookingConflictException e) {
        return createErrorResponse(req, e.getMessage());
    }

    @ExceptionHandler(BookingGuestException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ErrorDto onBookingGuestException(WebRequest req, BookingConflictException e) {
        return createErrorResponse(req, e.getMessage());
    }

    @ExceptionHandler(S3PutException.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ErrorDto onS3PutException(WebRequest req, S3PutException e) {
        return createErrorResponse(req, e.getMessage());
    }

    @ExceptionHandler(S3DeleteException.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ErrorDto onS3DeleteException(WebRequest req, S3DeleteException e) {
        return createErrorResponse(req, e.getMessage());
    }

    @ExceptionHandler(BookingDeleteException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ErrorDto onBookingDeleteException(WebRequest req, BookingDeleteException e) {
        return createErrorResponse(req, e.getMessage());
    }

    @ExceptionHandler(PasswordNotMatchException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ErrorDto onPasswordNotMatchException(WebRequest req, PasswordNotMatchException e) {
        return createErrorResponse(req, e.getMessage());
    }

    private ErrorDto createErrorResponse(WebRequest req, String message){
        HttpServletRequest httpServletRequest = (HttpServletRequest) req.resolveReference("request");
        assert httpServletRequest != null;
        return new ErrorDto(new Date(), httpServletRequest.getRequestURI(), message);
    }
}
