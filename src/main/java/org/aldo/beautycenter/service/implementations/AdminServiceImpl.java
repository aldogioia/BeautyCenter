package org.aldo.beautycenter.service.implementations;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.AdminDao;
import org.aldo.beautycenter.data.dto.create.CreateAdminDto;
import org.aldo.beautycenter.data.entities.Admin;
import org.aldo.beautycenter.service.interfaces.AdminService;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService {
    private final AdminDao adminDao;
    private final ModelMapper modelMapper;
    @Override
    public void createAdmin(CreateAdminDto createAdminDto) {
        adminDao.save(modelMapper.map(createAdminDto, Admin.class));
    }
}
