package org.aldo.beautycenter.config;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.ServiceDao;
import org.aldo.beautycenter.data.dto.CreateAdminDto;
import org.aldo.beautycenter.data.dto.CreateCustomerDto;
import org.aldo.beautycenter.data.dto.CreateOperatorDto;
import org.aldo.beautycenter.data.entities.Admin;
import org.aldo.beautycenter.data.entities.Customer;
import org.aldo.beautycenter.data.entities.Operator;
import org.aldo.beautycenter.data.enumerators.Role;
import org.modelmapper.PropertyMap;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import org.modelmapper.ModelMapper;

@Configuration
@RequiredArgsConstructor
public class ModelMapperConfig {
    private final ServiceDao serviceDao;
//    private final PasswordEncoder passwordEncoder;
    @Bean
    public ModelMapper modelMapper() {
        ModelMapper modelMapper = new ModelMapper();

//        Converter<String, String> passwordConverter = new Converter<String, String>() {
//            @Override
//            public String convert(MappingContext<String, String> context) {
//                return passwordEncoder.encode(context.getSource());
//            }
//        };

        //custom mappings here
//        modelMapper.addMappings(new PropertyMap<CreateOperatorDto, Operator>() {
//            @Override
//            protected void configure() {
//                map().setServices(serviceDao.findAllById(source.getServices()));
//            }
//        });
//
//        modelMapper.addMappings(new PropertyMap<UpdateOperatorDto, Operator>() {
//            @Override
//            protected void configure() {
//                map().setServices(serviceDao.findAllById(source.getServices()));
//            }
//        });

        modelMapper.addMappings(new PropertyMap<CreateAdminDto, Admin>() {
            @Override
            protected void configure() {
                map().setRole(Role.ROLE_ADMIN);
//                using(passwordConverter).map(source.getPassword(), destination.getPassword());
            }
        });

        modelMapper.addMappings(new PropertyMap<CreateOperatorDto, Operator>() {
            @Override
            protected void configure() {
                map().setRole(Role.ROLE_OPERATOR);
            }
        });

        modelMapper.addMappings(new PropertyMap<CreateCustomerDto, Customer>() {
            @Override
            protected void configure() {
                map().setRole(Role.ROLE_CUSTOMER);
            }
        });


        modelMapper.getConfiguration()
                .setFieldMatchingEnabled(true)
                .setFieldAccessLevel(org.modelmapper.config.Configuration.AccessLevel.PUBLIC);

        return modelMapper;
    }
}
