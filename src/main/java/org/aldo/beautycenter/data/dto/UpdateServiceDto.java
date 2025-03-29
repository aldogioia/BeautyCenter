package org.aldo.beautycenter.data.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidMultipartExtension;
import org.aldo.beautycenter.security.customAnnotation.annotation.ValidServiceId;
import org.springframework.web.multipart.MultipartFile;

@Data
public class UpdateServiceDto {
    @NotNull(message = "Il campo id è obbligatorio")
    @ValidServiceId
    private String id;

    @ValidMultipartExtension
    private MultipartFile image;

    @NotBlank(message = "Il campo name è obbligatorio")
    @Size(min = 1, max = 50, message = "Il campo name deve essere compreso tra 1 e 50 caratteri")
    private String name;

    @NotNull(message = "Il campo prezzo è obbligatorio")
    @Min(value = 1, message = "Il campo durata dev'essere almeno 1")
    private Double price;

    @NotNull(message = "Il campo durata è obbligatorio")
    @Min(value = 1, message = "Il campo durata dev'essere almeno 1")
    private Long duration;
}
