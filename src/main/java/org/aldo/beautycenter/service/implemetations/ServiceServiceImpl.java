package org.aldo.beautycenter.service.implemetations;

import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.ServiceDao;
import org.aldo.beautycenter.data.dto.CreateServiceDto;
import org.aldo.beautycenter.data.dto.ServiceDto;
import org.aldo.beautycenter.data.dto.UpdateServiceDto;
import org.aldo.beautycenter.security.exception.customException.S3DeleteException;
import org.aldo.beautycenter.service.interfaces.S3Service;
import org.aldo.beautycenter.service.interfaces.ServiceService;
import org.aldo.beautycenter.utils.Constants;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ServiceServiceImpl implements ServiceService {
    private final ServiceDao serviceDao;
    private final S3Service s3Service;
    private final ModelMapper modelMapper;
    @Override
    public List<ServiceDto> getAllServices() {
        return serviceDao.findAll()
                .stream()
                .map(service -> modelMapper.map(service, ServiceDto.class))
                .toList();
    }

    @Override
    public ServiceDto addService(CreateServiceDto createServiceDto) {
        org.aldo.beautycenter.data.entities.Service service = modelMapper.map(createServiceDto, org.aldo.beautycenter.data.entities.Service.class);
        service.setImgUrl(s3Service.uploadFile(createServiceDto.getImage(), Constants.SERVICE_FOLDER, createServiceDto.getName()));
        serviceDao.save(service);
        return modelMapper.map(service, ServiceDto.class);
    }

    @Override
    public String updateService(UpdateServiceDto updateServiceDto) {
        org.aldo.beautycenter.data.entities.Service service = serviceDao.getReferenceById(updateServiceDto.getId());
        modelMapper.map(updateServiceDto, org.aldo.beautycenter.data.entities.Service.class);
        if (updateServiceDto.getImage() != null)
            s3Service.uploadFile(updateServiceDto.getImage(), Constants.SERVICE_FOLDER, service.getName());
        serviceDao.save(service);
        return service.getImgUrl();
    }

    @Override
    @Transactional
    public void deleteService(String serviceId) {
        org.aldo.beautycenter.data.entities.Service service = serviceDao.findById(serviceId)
                .orElseThrow(() -> new EntityNotFoundException("Servizio non trovato"));

        String serviceName = service.getName();

        serviceDao.deleteById(serviceId);

        try {
            s3Service.deleteFile(Constants.SERVICE_FOLDER, serviceName);
        } catch (Exception e) {
            throw new S3DeleteException("Errore nella cancellazione del file su S3");
        }
    }
}
