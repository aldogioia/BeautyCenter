package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.create.CreateServiceDto;
import org.aldo.beautycenter.data.dto.responses.ServiceDto;
import org.aldo.beautycenter.data.dto.updates.UpdateServiceDto;

import java.util.List;

public interface ServiceService {
    List<ServiceDto> getAllServices();
    ServiceDto addService(CreateServiceDto createServiceDto);
    String updateService(UpdateServiceDto updateServiceDto);
    void deleteService(String serviceId);
}
