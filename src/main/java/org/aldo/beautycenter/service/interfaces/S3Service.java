package org.aldo.beautycenter.service.interfaces;

import org.springframework.web.multipart.MultipartFile;

public interface S3Service {
    void deleteFile(String folder, String fileName);
    String uploadFile(MultipartFile file, String folder, String name);
}
