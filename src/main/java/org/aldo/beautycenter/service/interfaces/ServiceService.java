package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.CreateServiceDto;
import org.aldo.beautycenter.data.dto.ServiceDto;
import org.aldo.beautycenter.data.dto.UpdateServiceDto;

import java.util.List;

public interface ServiceService {
    List<ServiceDto> getAllServices();
    ServiceDto addService(CreateServiceDto createServiceDto);
    String updateService(UpdateServiceDto updateServiceDto);
    void deleteService(String serviceId);
}
