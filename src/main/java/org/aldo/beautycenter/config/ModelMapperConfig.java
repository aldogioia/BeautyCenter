package org.aldo.beautycenter.config;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.*;
import org.aldo.beautycenter.data.entities.*;
import org.aldo.beautycenter.data.enumerators.Role;
import org.aldo.beautycenter.service.interfaces.S3Service;
import org.aldo.beautycenter.utils.Constants;
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
    private final S3Service s3Service;
    @Bean
    public ModelMapper modelMapper() {
        ModelMapper modelMapper = new ModelMapper();

        //converter per cryptare le passowrd
        Converter<String, String> passwordConverter = context -> passwordEncoder.encode(context.getSource());

        //converter per caricare le immagini
        Converter<CreateOperatorDto, String> operatorImageUploadConverter = context ->
                s3Service.uploadFile(context.getSource().getImage(), Constants.OPERATOR_FOLDER, context.getSource().getName());

//        Converter<CreateServiceDto, String> serviceImageUploadConverter = context ->
//                s3Service.uploadFile(context.getSource().getImage(), Constants.SERVICE_FOLDER, context.getSource().getName());

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
                using(operatorImageUploadConverter).map(source, destination.getImgUrl());
                skip().setOperatorServices(null);
            }
        });

        //mappatura per l'aggiornamento di un operatore
        modelMapper.addMappings(new PropertyMap<UpdateOperatorDto, Operator>() {
            @Override
            protected void configure() {
                skip().setImgUrl(null);
                skip().setOperatorServices(null);
            }
        });

        //mappatura per la creazione di un servizio
        modelMapper.addMappings(new PropertyMap<CreateServiceDto, Service>() {
            @Override
            protected void configure() {
                skip().setImgUrl(null);
//                using(serviceImageUploadConverter).map(source, destination.getImgUrl());
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

        //skip del campo services in RoomDto
        modelMapper.typeMap(Room.class, RoomDto.class)
                .addMappings(mapper -> mapper.skip(RoomDto::setServices));

        //skip del campo services in OperatorDto
        modelMapper.typeMap(Operator.class, OperatorDto.class)
                .addMappings(mapper -> mapper.skip(OperatorDto::setServices));

        //skip del campo roomServices
        modelMapper
                .typeMap(CreateRoomDto.class, Room.class)
                .addMappings(mapper -> mapper.skip(Room::setRoomServices));


        modelMapper.getConfiguration()
                .setFieldMatchingEnabled(true)
                .setFieldAccessLevel(org.modelmapper.config.Configuration.AccessLevel.PUBLIC);

        return modelMapper;
    }
}
