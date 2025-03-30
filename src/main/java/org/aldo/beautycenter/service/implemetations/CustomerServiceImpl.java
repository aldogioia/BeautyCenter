package org.aldo.beautycenter.service.implemetations;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.CustomerDao;
import org.aldo.beautycenter.data.dao.UserDao;
import org.aldo.beautycenter.data.dto.CreateCustomerDto;
import org.aldo.beautycenter.data.dto.CustomerDto;
import org.aldo.beautycenter.data.dto.UpdateCustomerDto;
import org.aldo.beautycenter.data.entities.Customer;
import org.aldo.beautycenter.security.exception.customException.EmailAlreadyUsed;
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
    public void createCustomer(CreateCustomerDto createCustomerDto) {
        customerDao.save(modelMapper.map(createCustomerDto, Customer.class));
    }

//    @Override
//    public CustomerDto getCustomerById(String id) {
//        Customer customer = customerDao.findById(id)
//                .orElseThrow(() -> new EntityNotFoundException("Cliente non trovato"));
//
//        return modelMapper.map(customer, CustomerDto.class);
//    }

    public void updateCustomer(UpdateCustomerDto updateCustomerDto) {
        userDao.findByEmail(updateCustomerDto.getEmail())
                .ifPresent(user -> {
                    if (user.getId().equals(updateCustomerDto.getId())) {
                        Customer customer = customerDao.getReferenceById(updateCustomerDto.getId());
                        modelMapper.map(updateCustomerDto, customer);
                        customerDao.save(customer);
                    }
                    else throw new EmailAlreadyUsed("Email già in uso");
                });
    }

    public void deleteCustomer(String Id) {
        customerDao.deleteById(Id);
    }
}
