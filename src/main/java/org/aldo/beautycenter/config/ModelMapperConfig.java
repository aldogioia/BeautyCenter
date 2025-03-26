package org.aldo.beautycenter.config;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.ServiceDao;
import org.aldo.beautycenter.data.dto.CreateOperatorDto;
import org.aldo.beautycenter.data.dto.UpdateOperatorDto;
import org.aldo.beautycenter.data.entities.Operator;
import org.modelmapper.PropertyMap;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import org.modelmapper.ModelMapper;

@Configuration
@RequiredArgsConstructor
public class ModelMapperConfig {
    private final ServiceDao serviceDao;
    @Bean
    public ModelMapper modelMapper() {
        ModelMapper modelMapper = new ModelMapper();

        //custom mappings here
        modelMapper.addMappings(new PropertyMap<CreateOperatorDto, Operator>() {
            @Override
            protected void configure() {
                map().setServices(serviceDao.findAllById(source.getServices()));
            }
        });

        modelMapper.addMappings(new PropertyMap<UpdateOperatorDto, Operator>() {
            @Override
            protected void configure() {
                map().setServices(serviceDao.findAllById(source.getServices()));
            }
        });

        modelMapper.getConfiguration()
                .setFieldMatchingEnabled(true)
                .setFieldAccessLevel(org.modelmapper.config.Configuration.AccessLevel.PUBLIC);

        return modelMapper;
    }
}
