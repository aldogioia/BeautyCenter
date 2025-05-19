package org.aldo.beautycenter.service.implementations;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.BlacklistDao;
import org.aldo.beautycenter.data.entities.Blacklist;
import org.aldo.beautycenter.security.authentication.JwtHandler;
import org.aldo.beautycenter.service.interfaces.BlacklistService;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;

@Service
@RequiredArgsConstructor
public class BlacklistServiceImpl implements BlacklistService {
    private final BlacklistDao blacklistDao;

    @Override
    public void addTokenToBlacklist(String token) {
        Blacklist blacklist = new Blacklist();
        blacklist.setExpiration(JwtHandler.getExpiratioTime(token));
        blacklist.setToken(token);
        blacklistDao.save(blacklist);
    }

    @Override
    public boolean isTokenBlacklisted(String token) {
        return blacklistDao.existsByToken(token);
    }

    @Scheduled(cron = "0 0 3 * * *")
    public void cleanUp() {
        blacklistDao.deleteByExpirationBefore(Date.from(Instant.now().truncatedTo(ChronoUnit.SECONDS)));
    }
}
