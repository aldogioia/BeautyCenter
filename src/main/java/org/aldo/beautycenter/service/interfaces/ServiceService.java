package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.CreateServiceDto;
import org.aldo.beautycenter.data.dto.ServiceDto;
import org.aldo.beautycenter.data.dto.UpdateServiceDto;

import java.util.List;

public interface ServiceService {
    List<ServiceDto> getAllServices();

    void addService(CreateServiceDto createServiceDto);

    void updateService(UpdateServiceDto updateServiceDto);

    void deleteService(String serviceId);
}
