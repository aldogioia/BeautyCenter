package org.aldo.beautycenter.service.implementations;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.CustomerDao;
import org.aldo.beautycenter.data.dao.UserDao;
import org.aldo.beautycenter.data.dto.create.CreateCustomerDto;
import org.aldo.beautycenter.data.dto.responses.CustomerDto;
import org.aldo.beautycenter.data.dto.updates.UpdateCustomerDto;
import org.aldo.beautycenter.data.entities.Customer;
import org.aldo.beautycenter.security.exception.customException.PhoneNumberConflictException;
import org.aldo.beautycenter.service.interfaces.CustomerService;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CustomerServiceImpl implements CustomerService {
    private final CustomerDao customerDao;
    private final UserDao userDao;
    private final ModelMapper modelMapper;

    @Override
    public List<CustomerDto> getAllCustomers() {
        return customerDao.findAll()
                .stream()
                .map(customer -> modelMapper.map(customer, CustomerDto.class))
                .toList();
    }

    @Override
    public CustomerDto getCustomerById(String id) {
        Customer customer = customerDao.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Utente non trovato"));

        return modelMapper.map(customer, CustomerDto.class);
    }

    @Override
    public void createCustomer(CreateCustomerDto createCustomerDto) {
        customerDao.save(modelMapper.map(createCustomerDto, Customer.class));
    }

    @Override
    public void updateCustomer(UpdateCustomerDto updateCustomerDto) {
        Customer customer = customerDao.findById(updateCustomerDto.getId())
                .orElseThrow(() -> new EntityNotFoundException("Utente non trovato"));

        userDao.findByPhoneNumber(updateCustomerDto.getPhoneNumber()).ifPresent(
                user -> {
                    if (!user.getId().equals(updateCustomerDto.getId()))
                        throw new PhoneNumberConflictException("Il numero di telefono è già associato ad un altro account");
                }
        );

        modelMapper.map(updateCustomerDto, customer);
        customerDao.save(customer);
    }

    @Override
    public void deleteCustomer(String Id) {
        customerDao.deleteById(Id);
    }
}
