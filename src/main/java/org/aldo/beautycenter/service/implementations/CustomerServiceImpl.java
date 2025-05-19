package org.aldo.beautycenter.service.implementations;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.CustomerDao;
import org.aldo.beautycenter.data.dto.create.CreateCustomerDto;
import org.aldo.beautycenter.data.dto.responses.CustomerDto;
import org.aldo.beautycenter.data.dto.updates.UpdateCustomerDto;
import org.aldo.beautycenter.data.entities.Customer;
import org.aldo.beautycenter.service.interfaces.CustomerService;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CustomerServiceImpl implements CustomerService {
    private final CustomerDao customerDao;
    private final ModelMapper modelMapper;

    @Override
    public List<CustomerDto> getAllCustomers() {
        return customerDao.findAll()
                .stream()
                .map(customer -> modelMapper.map(customer, CustomerDto.class))
                .toList();
    }

    @Override
    public void createCustomer(CreateCustomerDto createCustomerDto) {
        customerDao.save(modelMapper.map(createCustomerDto, Customer.class));
    }

    @Override
    public CustomerDto getCustomerById(String id) {
        Customer customer = customerDao.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Utente non trovato"));

        return modelMapper.map(customer, CustomerDto.class);
    }

    public void updateCustomer(UpdateCustomerDto updateCustomerDto) {
        Customer customer = customerDao.findById(updateCustomerDto.getId())
                .orElseThrow(() -> new EntityNotFoundException("Utente non trovato"));

        modelMapper.map(updateCustomerDto, customer);
        customerDao.save(customer);
    }

    public void deleteCustomer(String Id) {
        customerDao.deleteById(Id);
    }
}
