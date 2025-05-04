package org.aldo.beautycenter.service.implemetations;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.UserDao;
import org.aldo.beautycenter.data.entities.User;
import org.aldo.beautycenter.security.authorization.CustomUserDetails;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserDetailsServiceImpl implements UserDetailsService {
    private final UserDao userDao;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User user = userDao.findByEmail(email)
                .orElseThrow(() -> new EntityNotFoundException("Utente non trovato"));
        return new CustomUserDetails(user);
    }
    public String getCurrentUserEmail(){
        Authentication authentication= SecurityContextHolder.getContext().getAuthentication();
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        return userDetails.getUsername();
    }
}
