package org.aldo.beautycenter.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.auth.credentials.*;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.sts.StsClient;
import software.amazon.awssdk.services.sts.auth.StsAssumeRoleCredentialsProvider;
import software.amazon.awssdk.services.sts.model.AssumeRoleRequest;

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
    public StsClient baseStsClient() {
        AwsBasicCredentials baseCredentials = AwsBasicCredentials.create(accessKeyId, secretAccessKey);
        return StsClient.builder()
                .region(Region.of(region))
                .credentialsProvider(StaticCredentialsProvider.create(baseCredentials))
                .build();
    }

    @Bean
    public StsAssumeRoleCredentialsProvider assumeRoleCredentialsProvider(StsClient baseStsClient) {
        return StsAssumeRoleCredentialsProvider.builder()
                .refreshRequest(AssumeRoleRequest.builder()
                        .roleArn(roleArn)
                        .roleSessionName("session-name")
                        .build())
                .stsClient(baseStsClient)
                .build();
    }

    @Bean
    public S3Client s3Client(StsAssumeRoleCredentialsProvider credentialsProvider) {
        return S3Client.builder()
                .region(Region.of(region))
                .credentialsProvider(credentialsProvider)
                .build();
    }
}
