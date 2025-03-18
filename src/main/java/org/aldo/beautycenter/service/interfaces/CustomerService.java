package org.aldo.beautycenter.service.interfaces;

import org.aldo.beautycenter.data.dto.CreateCustomerDto;
import org.aldo.beautycenter.data.dto.UpdateCustomerDto;
import org.aldo.beautycenter.data.entities.User;

public interface CustomerService {
    void createCustomer(CreateCustomerDto createCustomerDto);
    User getCustomerByEmail(String email);
    void updateCustomer(UpdateCustomerDto updateCustomerDto);
    void deleteCustomer(String Id);
}
