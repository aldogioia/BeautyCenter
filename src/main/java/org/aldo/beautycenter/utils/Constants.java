package org.aldo.beautycenter.utils;

public final class Constants {
    private Constants() {
        throw new UnsupportedOperationException("This class is  an utility class and cannot be instantiated");
    }

    //AWS
    public static final String S3_BUCKET_NAME = "beauty-center-images";
    public static final String OPERATOR_FOLDER = "operators";
    public static final String SERVICE_FOLDER = "services";

    //WhatsApp
    public static final String WHATSAPP_API_URL = "https://graph.facebook.com/v19.0/";
    public static final String WHATSAPP_MESSAGE_END_POINT = "/messages";
    public static final String TEMPLATE_RECOVERY_PASSWORD = "recovery-password";
    public static final String TEMPLATE_CONFIRMATION_BOOKING = "confirmation-booking";
    public static final String TEMPLATE_REMINDER_BOOKING = "reminder-booking";
    public static final String TEMPLATE_CANCEL_BOOKING = "cancel-booking";
}
