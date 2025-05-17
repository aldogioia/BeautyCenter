package org.aldo.beautycenter.service.implementations;

import lombok.RequiredArgsConstructor;
import org.aldo.beautycenter.data.dao.BlacklistDao;
import org.aldo.beautycenter.data.entities.Blacklist;
import org.aldo.beautycenter.service.interfaces.BlacklistService;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class BlacklistServiceImpl implements BlacklistService {
    private final BlacklistDao blacklistDao;
    @Override
    public void addTokenToBlacklist(String token) {
        Blacklist blacklist = new Blacklist();
        blacklist.setToken(token);
        blacklistDao.save(blacklist);
    }

    @Override
    public boolean isTokenBlacklisted(String token) {
        return blacklistDao.existsByToken(token);
    }
}
