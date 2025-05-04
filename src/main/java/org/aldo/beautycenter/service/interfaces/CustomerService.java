package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.CreateCustomerDto;
import org.aldo.beautycenter.data.dto.CustomerDto;
import org.aldo.beautycenter.data.dto.UpdateCustomerDto;

import java.util.List;

public interface CustomerService {
    List<CustomerDto> getAllCustomers();
    void createCustomer(CreateCustomerDto createCustomerDto);
    CustomerDto getCustomerById(String email);
    void updateCustomer(UpdateCustomerDto updateCustomerDto);
    void deleteCustomer(String Id);
}
