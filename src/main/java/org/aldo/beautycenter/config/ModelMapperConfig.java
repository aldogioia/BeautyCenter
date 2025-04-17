package org.aldo.beautycenter.config;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.CustomerDao;
import org.aldo.beautycenter.data.dao.OperatorDao;
import org.aldo.beautycenter.data.dao.ServiceDao;
import org.aldo.beautycenter.data.dto.*;
import org.aldo.beautycenter.data.entities.*;
import org.aldo.beautycenter.data.enumerators.Role;
import org.aldo.beautycenter.service.interfaces.S3Service;
import org.modelmapper.Converter;
import org.modelmapper.PropertyMap;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import org.modelmapper.ModelMapper;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
@RequiredArgsConstructor
public class ModelMapperConfig {
    private final PasswordEncoder passwordEncoder;
    private final ServiceDao serviceDao;
    private final OperatorDao operatorDao;
    private final CustomerDao customerDao;
    private final S3Service s3Service;
    @Bean
    public ModelMapper modelMapper() {
        ModelMapper modelMapper = new ModelMapper();

        //converter per cryptare le password
        Converter<String, String> passwordConverter = context -> passwordEncoder.encode(context.getSource());

        //converter per gli url delle immagini
        Converter<String, String> imageUrlConverter = context -> s3Service.presignedUrl(context.getSource());

        //mappatura per la creazione di un admin
        modelMapper.addMappings(new PropertyMap<CreateAdminDto, Admin>() {
            @Override
            protected void configure() {
                map().setRole(Role.ROLE_ADMIN);
                using(passwordConverter).map(source.getPassword(), destination.getPassword());
            }
        });

        //mappatura per la creazione di un operatore
        modelMapper.addMappings(new PropertyMap<CreateOperatorDto, Operator>() {
            @Override
            protected void configure() {
                map().setRole(Role.ROLE_OPERATOR);
                skip().setImgUrl(null);
                skip().setServices(null);
            }
        });

        //mappatura per l'aggiornamento di un operatore
        modelMapper.addMappings(new PropertyMap<UpdateOperatorDto, Operator>() {
            @Override
            protected void configure() {
                skip().setImgUrl(null);
                skip().setServices(null);
            }
        });

        //mappatura per la creazione di una prenotazione
        modelMapper.addMappings(new PropertyMap<CreateBookingDto, Booking>() {
            @Override
            protected void configure() {
                using(ctx -> serviceDao.findById((String) ctx.getSource()).orElseThrow(() -> new EntityNotFoundException("Servizio non trovato")))
                        .map(source.getService(), destination.getService());
                using(ctx -> operatorDao.findById((String) ctx.getSource()).orElseThrow(() -> new EntityNotFoundException("Operatore non trovato")))
                        .map(source.getOperator(), destination.getOperator());
                using(ctx -> customerDao.findById((String) ctx.getSource()).orElseThrow(() -> new EntityNotFoundException("Cliente non trovato")))
                        .map(source.getCustomer(), destination.getCustomer());
            }
        });

        //mappatura per la creazione di un turno standard
        modelMapper.addMappings(new PropertyMap<CreateStandardScheduleDto, StandardSchedule>() {
            @Override
            protected void configure() {
                skip().setId(null);
                using(ctx -> operatorDao.findById((String) ctx.getSource()).orElseThrow(() -> new EntityNotFoundException("Operatore non trovato")))
                        .map(source.getOperatorId(), destination.getOperator());
            }
        });

        //mappatura per l'aggiornamento di un turno standard
        modelMapper.addMappings(new PropertyMap<UpdateStandardScheduleDto, StandardSchedule>() {
            @Override
            protected void configure() {
                using(ctx -> operatorDao.findById((String) ctx.getSource()).orElseThrow(() -> new EntityNotFoundException("Operatore non trovato")))
                        .map(source.getOperatorId(), destination.getOperator());
            }
        });

        //mappatura per la creazione dell'eccezione di un turno
        modelMapper.addMappings(new PropertyMap<CreateScheduleExceptionDto, StandardSchedule>() {
            @Override
            protected void configure() {
                using(ctx -> operatorDao.findById((String) ctx.getSource()).orElseThrow(() -> new EntityNotFoundException("Operatore non trovato")))
                        .map(source.getOperatorId(), destination.getOperator());
            }
        });

        //mappatura per l'aggiornamento di un turno standard
        modelMapper.addMappings(new PropertyMap<UpdateScheduleExceptionDto, StandardSchedule>() {
            @Override
            protected void configure() {
                using(ctx -> operatorDao.findById((String) ctx.getSource()).orElseThrow(() -> new EntityNotFoundException("Operatore non trovato")))
                        .map(source.getOperatorId(), destination.getOperator());
            }
        });

        //mappatura per la creazione di un servizio
        modelMapper.addMappings(new PropertyMap<CreateServiceDto, Service>() {
            @Override
            protected void configure() {
                skip().setImgUrl(null);
            }
        });

        //mappatura per l'aggiornamento di un servizio
        modelMapper.addMappings(new PropertyMap<UpdateServiceDto, Service>() {
            @Override
            protected void configure() {
                skip().setImgUrl(null);
            }
        });

        //mappatura per la creazione di un customer
        modelMapper.addMappings(new PropertyMap<CreateCustomerDto, Customer>() {
            @Override
            protected void configure() {
                map().setRole(Role.ROLE_CUSTOMER);
                using(passwordConverter).map(source.getPassword(), destination.getPassword());
            }
        });

        //mappatura per il bookingDto
        modelMapper.addMappings(new PropertyMap<Booking, BookingDto>() {
            @Override
            protected void configure() {
                map().setRoom(source.getRoom().getId());

                using(ctx -> modelMapper.map(source.getService(), SummaryServiceDto.class))
                        .map(source, destination.getService());
                using(ctx -> modelMapper.map(source.getOperator(), SummaryOperatorDto.class))
                        .map(source, destination.getOperator());
                using(ctx -> modelMapper.map(source.getCustomer(), SummaryCustomerDto.class))
                        .map(source, destination.getCustomer());
            }
        });

        //mappatura per l'operatorDto
        modelMapper.addMappings(new PropertyMap<Operator, OperatorDto>() {
            @Override
            protected void configure() {
                using(imageUrlConverter).map(source.getImgUrl(), destination.getImgUrl());
            }
        });

        //mappatura per il serviceDto
        modelMapper.addMappings(new PropertyMap<Service, ServiceDto>() {
            @Override
            protected void configure() {
                using(imageUrlConverter).map(source.getImgUrl(), destination.getImgUrl());
            }
        });

        //mappatura per il SummaryOperatorDto
        modelMapper.addMappings(new PropertyMap<Operator, SummaryOperatorDto>() {
            @Override
            protected void configure() {
                using(imageUrlConverter).map(source.getImgUrl(), destination.getImgUrl());
            }
        });
        //skip del campo services in RoomDto
        modelMapper.typeMap(Room.class, RoomDto.class)
                .addMappings(mapper -> mapper.skip(RoomDto::setServices));

        //skip del campo services in OperatorDto
        modelMapper.typeMap(Operator.class, OperatorDto.class)
                .addMappings(mapper -> mapper.skip(OperatorDto::setServices));

        //skip del campo roomServices
        modelMapper
                .typeMap(CreateRoomDto.class, Room.class)
                .addMappings(mapper -> mapper.skip(Room::setServices));


        modelMapper.getConfiguration()
                .setFieldMatchingEnabled(true)
                .setFieldAccessLevel(org.modelmapper.config.Configuration.AccessLevel.PUBLIC);

        return modelMapper;
    }
}
