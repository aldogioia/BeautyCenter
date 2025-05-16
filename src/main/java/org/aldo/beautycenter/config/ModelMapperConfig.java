package org.aldo.beautycenter.config;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.OperatorDao;
import org.aldo.beautycenter.data.dao.ServiceDao;
import org.aldo.beautycenter.data.dao.ToolDao;
import org.aldo.beautycenter.data.dto.create.*;
import org.aldo.beautycenter.data.dto.responses.BookingDto;
import org.aldo.beautycenter.data.dto.responses.OperatorDto;
import org.aldo.beautycenter.data.dto.responses.RoomDto;
import org.aldo.beautycenter.data.dto.responses.ServiceDto;
import org.aldo.beautycenter.data.dto.summaries.SummaryCustomerDto;
import org.aldo.beautycenter.data.dto.summaries.SummaryOperatorDto;
import org.aldo.beautycenter.data.dto.summaries.SummaryServiceDto;
import org.aldo.beautycenter.data.dto.summaries.SummaryToolDto;
import org.aldo.beautycenter.data.dto.updates.*;
import org.aldo.beautycenter.data.entities.*;
import org.aldo.beautycenter.data.enumerators.Role;
import org.modelmapper.Converter;
import org.modelmapper.PropertyMap;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import org.modelmapper.ModelMapper;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Configuration
@RequiredArgsConstructor
public class ModelMapperConfig {
    private final PasswordEncoder passwordEncoder;
    private final ServiceDao serviceDao;
    private final ToolDao toolDao;
    private final OperatorDao operatorDao;

    @Bean
    public ModelMapper modelMapper() {
        ModelMapper modelMapper = new ModelMapper();

        //converter per cryptare le password
        Converter<String, String> passwordConverter = context -> passwordEncoder.encode(context.getSource());

        Converter<List<String>, List<Service>> serviceIdToServiceConverter = ctx -> {
            List<String> ids = ctx.getSource();
            if (ids == null) return Collections.emptyList();

            return ids.stream()
                    .map(id -> serviceDao.findById(id)
                            .orElseThrow(() -> new EntityNotFoundException("Servizio non trovato con ID: " + id)))
                    .collect(Collectors.toList());
        };

        Converter<List<String>, List<Tool>> toolIdToToolConverter = ctx -> {
            List<String> ids = ctx.getSource();
            if (ids == null) return Collections.emptyList();

            return ids.stream()
                    .map(id -> toolDao.findById(id)
                            .orElseThrow(() -> new EntityNotFoundException("Macchinario non trovato con ID: " + id)))
                    .collect(Collectors.toList());
        };

        //mappatura per la creazione di un admin
        modelMapper.addMappings(new PropertyMap<CreateAdminDto, Admin>() {
            @Override
            protected void configure() {
                map().setRole(Role.ROLE_ADMIN);
                using(passwordConverter).map(source.getPassword(), destination.getPassword());
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
        modelMapper.addMappings(new PropertyMap<CreateScheduleExceptionDto, ScheduleException>() {
            @Override
            protected void configure() {
                skip().setId(null);
                using(ctx -> operatorDao.findById((String) ctx.getSource()).orElseThrow(() -> new EntityNotFoundException("Operatore non trovato")))
                        .map(source.getOperatorId(), destination.getOperator());
            }
        });

        //mappatura per l'aggiornamento di un turno standard
        modelMapper.addMappings(new PropertyMap<UpdateScheduleExceptionDto, ScheduleException>() {
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
                using(toolIdToToolConverter).map(source.getTools(), destination.getTools());
            }
        });

        //mappatura per l'aggiornamento di un servizio
        modelMapper.addMappings(new PropertyMap<UpdateServiceDto, Service>() {
            @Override
            protected void configure() {
                skip().setImgUrl(null);
                using(toolIdToToolConverter).map(source.getTools(), destination.getTools());
            }
        });

        //mappatura per l'operatorDto
        modelMapper.addMappings(new PropertyMap<Service, ServiceDto>() {
            @Override
            protected void configure() {
                using(ctx -> ((Collection<?>) ctx.getSource()).stream()
                        .map(tool -> modelMapper.map(tool, SummaryToolDto.class))
                        .collect(Collectors.toList()))
                        .map(source.getTools(), destination.getTools());
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

        //mappatura per la creazione di un Booking
        modelMapper.addMappings(new PropertyMap<CreateBookingDto, Booking>() {
            @Override
            protected void configure() {
                skip().setOperator(null);
                skip().setService(null);
                skip().setRoom(null);
                skip().setBookedForCustomer(null);
            }
        });

        //mappatura per il bookingDto
        modelMapper.addMappings(new PropertyMap<Booking, BookingDto>() {
            @Override
            protected void configure() {
                map().setRoom(source.getRoom().getName());

                // Service
                using(ctx -> {
                    Booking source = (Booking) ctx.getSource();
                    return source.getService() != null
                            ? modelMapper.map(source.getService(), ServiceDto.class)
                            : null;
                }).map(source, destination.getService());

                // Operator
                using(ctx -> {
                    Booking source = (Booking) ctx.getSource();
                    return source.getOperator() != null
                            ? modelMapper.map(source.getOperator(), SummaryOperatorDto.class)
                            : null;
                }).map(source, destination.getOperator());

                // Customer
                using(ctx -> {
                    Booking source = (Booking) ctx.getSource();
                    return source.getBookedForCustomer() != null
                            ? modelMapper.map(source.getBookedForCustomer(), SummaryCustomerDto.class)
                            : null;
                }).map(source, destination.getBookedForCustomer());
            }
        });

        //mappatura per la creazione di un operator
        modelMapper.addMappings(new PropertyMap<CreateOperatorDto, Operator>() {
            @Override
            protected void configure() {
                map().setRole(Role.ROLE_OPERATOR);
                skip().setImgUrl(null);
                using(serviceIdToServiceConverter).map(source.getServices(), destination.getServices());
            }
        });

        //mappatura per l'aggiornamento di un operator
        modelMapper.addMappings(new PropertyMap<UpdateOperatorDto, Operator>() {
            @Override
            protected void configure() {
                skip().setImgUrl(null);
                using(serviceIdToServiceConverter).map(source.getServices(), destination.getServices());
            }
        });

        //mappatura per l'operatorDto
        modelMapper.addMappings(new PropertyMap<Operator, OperatorDto>() {
            @Override
            protected void configure() {
                using(ctx -> ((Collection<?>) ctx.getSource()).stream()
                        .map(service -> modelMapper.map(service, SummaryServiceDto.class))
                        .collect(Collectors.toList()))
                        .map(source.getServices(), destination.getServices());
            }
        });

        //mappatura per la creazione di una room
        modelMapper.addMappings(new PropertyMap<CreateRoomDto, Room>() {
            @Override
            protected void configure() {
                using(serviceIdToServiceConverter).map(source.getServices(), destination.getServices());
            }
        });

        //mappatura per l'aggiornamento di una room
        modelMapper.addMappings(new PropertyMap<UpdateRoomDto, Room>() {
            @Override
            protected void configure() {
                using(serviceIdToServiceConverter).map(source.getServices(), destination.getServices());
            }
        });

        //mappatura per il roomDto
        modelMapper.addMappings(new PropertyMap<Room, RoomDto>() {
            @Override
            protected void configure() {
                using(ctx -> ((Collection<?>) ctx.getSource()).stream()
                        .map(service -> modelMapper.map(service, SummaryServiceDto.class))
                        .collect(Collectors.toList()))
                        .map(source.getServices(), destination.getServices());
            }
        });


        modelMapper.getConfiguration()
                .setFieldMatchingEnabled(true)
                .setFieldAccessLevel(org.modelmapper.config.Configuration.AccessLevel.PUBLIC);

        return modelMapper;
    }
}
