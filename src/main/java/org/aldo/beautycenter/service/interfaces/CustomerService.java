package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.create.CreateCustomerDto;
import org.aldo.beautycenter.data.dto.responses.CustomerDto;
import org.aldo.beautycenter.data.dto.updates.UpdateCustomerDto;

import java.util.List;

public interface CustomerService {
    List<CustomerDto> getAllCustomers();
    void createCustomer(CreateCustomerDto createCustomerDto);
    CustomerDto getCustomerById(String email);
    void updateCustomer(UpdateCustomerDto updateCustomerDto);
    void deleteCustomer(String Id);
}
