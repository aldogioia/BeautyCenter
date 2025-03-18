package org.aldo.beautycenter.service.implemetations;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.CustomerDao;
import org.aldo.beautycenter.data.dto.CreateCustomerDto;
import org.aldo.beautycenter.data.dto.UpdateCustomerDto;
import org.aldo.beautycenter.data.entities.Customer;
import org.aldo.beautycenter.service.interfaces.CustomerService;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CustomerServiceImpl implements CustomerService {
    private final CustomerDao customerDao;
    private final ModelMapper modelMapper;

    @Override
    public void createCustomer(CreateCustomerDto createCustomerDto) {
        Customer customer = modelMapper.map(createCustomerDto, Customer.class);
        customerDao.save(customer);
    }

    @Override
    public Customer getCustomerByEmail(String email) {
        return customerDao.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Customer not found"));
    }

    public void updateCustomer(UpdateCustomerDto updateCustomerDto) {
        Customer customer = customerDao.findById(updateCustomerDto.getId())
                .orElseThrow(() -> new RuntimeException("Customer not found"));

        customer.setEmail(updateCustomerDto.getEmail());
        customer.setPhoneNumber(updateCustomerDto.getPhoneNumber());

        customerDao.save(customer);
    }

    public void deleteCustomer(String Id) {
        customerDao.deleteById(Id);
    }
}
