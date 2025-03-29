package org.aldo.beautycenter.service.implemetations;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.security.exception.customException.S3PutException;
import org.aldo.beautycenter.service.interfaces.S3Service;
import org.aldo.beautycenter.utils.Constants;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.services.s3.presigner.model.GetObjectPresignRequest;

import java.io.IOException;
import java.time.Duration;

@Service
@RequiredArgsConstructor
public class S3ServiceImpl implements S3Service {
    private final S3Client s3Client;
    private final S3Presigner s3Presigner;
    private final String bucketName = Constants.S3_BUCKET_NAME;

    @Override
    public String presignedUrl(String url) {
        String[] urlParts = url.replace("https://", "").split("/", 2);
        String key = urlParts[1];

        GetObjectRequest getObjectRequest = GetObjectRequest.builder()
                .bucket(bucketName)
                .key(key)
                .build();

        GetObjectPresignRequest getObjectPresignRequest = GetObjectPresignRequest.builder()
                .signatureDuration(Duration.ofMinutes(Constants.SECURE_URL_EXPIRATION))
                .getObjectRequest(getObjectRequest)
                .build();
        return s3Presigner.presignGetObject(getObjectPresignRequest).url().toString();
    }

    @Override
    public String uploadFile(MultipartFile file, String folder, String name) {
        String key = folder + "/" + name.replace(" ", "_");
        PutObjectRequest putRequest = PutObjectRequest.builder()
                .bucket(bucketName)
                .key(key)
                .contentType(file.getContentType())
                .build();
        try{
            s3Client.putObject(putRequest, RequestBody.fromInputStream(file.getInputStream(), file.getSize()));
        } catch (IOException e) {
            throw new S3PutException("Error uploading file to S3");
        }
        return s3Client.utilities().getUrl(builder -> builder.bucket(bucketName).key(key)).toExternalForm();
    }
}
