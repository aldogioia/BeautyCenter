package org.aldo.beautycenter.utils;

public final class Constants {
    private Constants() {
        throw new UnsupportedOperationException("This class is  an utility class and cannot be instantiated");
    }

    public static final String S3_BUCKET_NAME = "beauty-center-images";
    public static final Integer SECURE_URL_EXPIRATION = 10;
    public static final String OPERATOR_FOLDER = "operators";
    public static final String SERVICE_FOLDER = "services";
}
