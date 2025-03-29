package org.aldo.beautycenter.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.AwsCredentials;
import software.amazon.awssdk.auth.credentials.AwsSessionCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.services.sts.StsClient;
import software.amazon.awssdk.services.sts.model.AssumeRoleRequest;
import software.amazon.awssdk.services.sts.model.AssumeRoleResponse;

@Configuration
public class AwsConfig {
    @Value("${aws.roleArn}")
    private String roleArn;
    @Value("${aws.region}")
    private String region;
    @Value("${aws.accessKeyId}")
    private String accessKeyId;
    @Value("${aws.secretAccessKey}")
    private String secretAccessKey;
    @Bean
    public StsClient stsClient() {
        AwsCredentials awsCredentials= AwsBasicCredentials.create(accessKeyId, secretAccessKey);
        return StsClient.builder()
                .region(Region.of(region))
                .credentialsProvider(StaticCredentialsProvider.create(awsCredentials))
                .build();
    }
    @Bean
    public AwsSessionCredentials awsSessionCredentials(StsClient stsClient) {
        AssumeRoleRequest assumeRoleRequest = AssumeRoleRequest.builder()
                .roleArn(roleArn)
                .roleSessionName("session-name")
                .build();
        AssumeRoleResponse assumeRoleResponse = stsClient.assumeRole(assumeRoleRequest);
        return AwsSessionCredentials.create(
                assumeRoleResponse.credentials().accessKeyId(),
                assumeRoleResponse.credentials().secretAccessKey(),
                assumeRoleResponse.credentials().sessionToken()
        );
    }

    @Bean
    public S3Presigner s3Presigner(AwsSessionCredentials awsSessionCredentials) {
        return S3Presigner.builder()
                .region(Region.of(region))
                .credentialsProvider(StaticCredentialsProvider.create(awsSessionCredentials))
                .build();
    }

    @Bean
    public S3Client s3Client(AwsSessionCredentials awsSessionCredentials) {
        return S3Client.builder()
                .region(Region.of(region))
                .credentialsProvider(StaticCredentialsProvider.create(awsSessionCredentials))
                .build();
    }
}
