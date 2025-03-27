package org.aldo.beautycenter.service.interfaces;

public interface BlacklistService {
    void addTokenToBlacklist(String token);
    boolean isTokenBlacklisted(String token);
}
