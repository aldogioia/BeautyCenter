package org.aldo.beautycenter.service.implemetations;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.AdminDao;
import org.aldo.beautycenter.data.dto.CreateAdminDto;
import org.aldo.beautycenter.data.entities.Admin;
import org.aldo.beautycenter.service.interfaces.AdminService;
import org.modelmapper.ModelMapper;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService {
    private final AdminDao adminDao;
    private final PasswordEncoder passwordEncoder;
    private final ModelMapper modelMapper;
    @Override
    public void createAdmin(CreateAdminDto createAdminDto) {
        Admin admin = modelMapper.map(createAdminDto, Admin.class);
        admin.setPassword(passwordEncoder.encode(admin.getPassword()));
        adminDao.save(admin);
    }
}
