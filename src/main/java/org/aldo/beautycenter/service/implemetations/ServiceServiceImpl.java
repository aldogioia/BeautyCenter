package org.aldo.beautycenter.service.implemetations;

import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.ServiceDao;
import org.aldo.beautycenter.data.dto.create.CreateServiceDto;
import org.aldo.beautycenter.data.dto.responses.ServiceDto;
import org.aldo.beautycenter.data.dto.updates.UpdateServiceDto;
import org.aldo.beautycenter.security.exception.customException.S3DeleteException;
import org.aldo.beautycenter.service.interfaces.NotificationService;
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
    private final NotificationService notificationService;
    private final ModelMapper modelMapper;

    @Override
    public List<ServiceDto> getAllServices() {
        return serviceDao.findAll()
                .stream()
                .map(service -> modelMapper.map(service, ServiceDto.class))
                .toList();
    }

    @Override
    @Transactional
    public ServiceDto addService(CreateServiceDto createServiceDto) {
        org.aldo.beautycenter.data.entities.Service service = modelMapper.map(createServiceDto, org.aldo.beautycenter.data.entities.Service.class);
        service.setImgUrl(s3Service.uploadFile(createServiceDto.getImage(), Constants.SERVICE_FOLDER, createServiceDto.getName()));
        serviceDao.save(service);
        return modelMapper.map(service, ServiceDto.class);
    }

    @Override
    @Transactional
    public String updateService(UpdateServiceDto updateServiceDto) {
        org.aldo.beautycenter.data.entities.Service service = serviceDao.findById(updateServiceDto.getId())
                .orElseThrow(() -> new EntityNotFoundException("Servizio non trovato"));

        modelMapper.map(updateServiceDto, service);
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

        if (service.getOperators() != null) {
            service.getOperators().forEach(operator -> operator.getServices().remove(service));
            service.getOperators().clear();
        }

        if (service.getRooms() != null) {
            service.getRooms().forEach(room -> room.getServices().remove(service));
            service.getRooms().clear();
        }

        if (service.getRooms() != null) {
            service.getTools().forEach(tool -> tool.getServices().remove(service));
            service.getTools().clear();
        }

        notificationService.sendNotificationBeforeDeletingBooking(service.getBookings());

        serviceDao.delete(service);

        try {
            s3Service.deleteFile(Constants.SERVICE_FOLDER, serviceName);
        } catch (Exception e) {
            System.out.println("Errore s3: " + e.getMessage());
            throw new S3DeleteException("Errore nella cancellazione del file su S3");
        }
    }
}
