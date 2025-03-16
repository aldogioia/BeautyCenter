package org.aldo.beautycenter.security.logging;

import io.micrometer.common.lang.NonNullApi;
import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.sercice.Implemetation.UserDetailsServiceImpl;
import org.springframework.data.domain.AuditorAware;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
@RequiredArgsConstructor
@NonNullApi
public class AuditorAwareImpl implements AuditorAware<String> {
    private final UserDetailsServiceImpl userDetailsServiceImpl;

    @Override
    public Optional<String> getCurrentAuditor() {
        try {
            return Optional.of(userDetailsServiceImpl.getCurrentUserEmail());
        } catch (Exception e) {
            return Optional.of("system");
        }
    }
}
