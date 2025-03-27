package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.CreateCustomerDto;
import org.aldo.beautycenter.data.dto.CustomerDto;
import org.aldo.beautycenter.data.dto.UpdateCustomerDto;

public interface CustomerService {
    void createCustomer(CreateCustomerDto createCustomerDto);
    CustomerDto getCustomerById(String email);
    void updateCustomer(UpdateCustomerDto updateCustomerDto);
    void deleteCustomer(String Id);
}
