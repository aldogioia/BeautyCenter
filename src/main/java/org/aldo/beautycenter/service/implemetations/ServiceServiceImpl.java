package org.aldo.beautycenter.service.implemetations;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.ServiceDao;
import org.aldo.beautycenter.data.dto.CreateServiceDto;
import org.aldo.beautycenter.data.dto.ServiceDto;
import org.aldo.beautycenter.data.dto.UpdateServiceDto;
import org.aldo.beautycenter.service.interfaces.ServiceService;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ServiceServiceImpl implements ServiceService {
    private final ServiceDao serviceDao;
    private final ModelMapper modelMapper;
    @Override
    public List<ServiceDto> getAllServices() {
        return serviceDao.findAll()
                .stream()
                .map(service -> modelMapper.map(service, ServiceDto.class))
                .toList();
    }

    @Override
    public void addService(CreateServiceDto createServiceDto) {
        serviceDao.save(modelMapper.map(createServiceDto, org.aldo.beautycenter.data.entities.Service.class));
    }

    @Override
    public void updateService(UpdateServiceDto updateServiceDto) {
        org.aldo.beautycenter.data.entities.Service service = serviceDao
                .findById(updateServiceDto.getId()).orElseThrow(() -> new RuntimeException("Service not found"));

        service.setName(updateServiceDto.getName());
        service.setPrice(updateServiceDto.getPrice());
        service.setDuration(updateServiceDto.getDuration());

        serviceDao.save(service);
    }

    @Override
    public void deleteService(String serviceId) {
        serviceDao.deleteById(serviceId);
    }
}
