package org.aldo.beautycenter.config;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dto.*;
import org.aldo.beautycenter.data.entities.*;
import org.aldo.beautycenter.data.enumerators.Role;
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
    @Bean
    public ModelMapper modelMapper() {
        ModelMapper modelMapper = new ModelMapper();

        //converter per cryptare le passowrd
        Converter<String, String> passwordConverter = context -> passwordEncoder.encode(context.getSource());

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
                skip().setOperatorServices(null);
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
