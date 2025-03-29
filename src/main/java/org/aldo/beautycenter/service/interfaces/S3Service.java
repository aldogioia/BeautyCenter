package org.aldo.beautycenter.service.interfaces;

import org.springframework.web.multipart.MultipartFile;

public interface S3Service {
    String presignedUrl(String url);
    String uploadFile(MultipartFile file, String folder, String name);
}
