package org.aldo.beautycenter.security.availability;

import com.google.common.util.concurrent.RateLimiter;
import lombok.RequiredArgsConstructor;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;
import java.util.concurrent.ConcurrentHashMap;

@Aspect
@Component
@RequiredArgsConstructor
public class RateLimitingAspect {

    private final ConcurrentHashMap<Method, RateLimiter> rateLimiterMap = new ConcurrentHashMap<>();

    @Around("@within(org.springframework.web.bind.annotation.RestController)")
    public Object limitRequestRate(ProceedingJoinPoint joinPoint) throws Throwable {
        Method method= ((MethodSignature) joinPoint.getSignature()).getMethod();
        RateLimit rateLimited = method.getAnnotation(RateLimit.class);  // Se l'annotazione è presente sul metodo, usa quella altrimenti, cerca l'annotazione sulla classe
        if (rateLimited == null) {
            rateLimited = joinPoint.getTarget().getClass().getAnnotation(RateLimit.class);
        }
        if (rateLimited != null) {
            final double permitsPerSecond = rateLimited.permitsPerSecond();
            RateLimiter rateLimiter = rateLimiterMap.computeIfAbsent(method, key -> RateLimiter.create(permitsPerSecond));

            if (rateLimiter.tryAcquire()) {
                return joinPoint.proceed();
            } else {
                throw new RuntimeException("Too many requests");
            }
        } else {
            return joinPoint.proceed();
        }
    }
}
