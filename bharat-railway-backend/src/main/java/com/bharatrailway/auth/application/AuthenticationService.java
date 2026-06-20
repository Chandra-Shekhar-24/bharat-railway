/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-backend
 * Branch: feature/backend-developer-hitanshu
 * Developer: Hitanshu Dhakrey
 * Assisted by: Chandra Shekhar Bansal (Infrastructure), DeepSeek (AI Scribe)
 * Date: 2026-06-20
 * Version: 0.1.0-SNAPSHOT
 *
 * Description:
 * Authentication service orchestrating login flow.
 * Validates credentials, enforces lockout logic, generates JWT,
 * creates session in auth_schema.user_sessions, and logs to login_history.
 * Failure operations use REQUIRES_NEW to commit despite parent rollback.
 */

package com.bharatrailway.auth.application;

import java.time.OffsetDateTime;
import java.util.UUID;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.bharatrailway.auth.application.dto.LoginRequest;
import com.bharatrailway.auth.application.dto.LoginResponse;
import com.bharatrailway.auth.domain.LoginHistory;
import com.bharatrailway.auth.domain.UserSession;
import com.bharatrailway.auth.infrastructure.LoginHistoryRepository;
import com.bharatrailway.auth.infrastructure.UserSessionRepository;
import com.bharatrailway.identity.domain.User;
import com.bharatrailway.identity.infrastructure.UserRepository;

@Service
public class AuthenticationService {

    private static final int MAX_FAILED_ATTEMPTS = 5;
    private static final long LOCK_DURATION_MINUTES = 30;

    private final UserRepository userRepository;
    private final UserSessionRepository userSessionRepository;
    private final LoginHistoryRepository loginHistoryRepository;
    private final BCryptPasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthenticationService(UserRepository userRepository,
                                 UserSessionRepository userSessionRepository,
                                 LoginHistoryRepository loginHistoryRepository,
                                 BCryptPasswordEncoder passwordEncoder,
                                 JwtService jwtService) {
        this.userRepository = userRepository;
        this.userSessionRepository = userSessionRepository;
        this.loginHistoryRepository = loginHistoryRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    public LoginResponse login(LoginRequest request, String ipAddress, String userAgent) {
        User user = userRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> {
                    logFailureNoUser(request.getUsername(), ipAddress, userAgent, "User not found");
                    return new BadCredentialsException("Invalid username or password");
                });

        if (user.getStatus() == 0) {
            logFailure(user, ipAddress, userAgent, "Account inactive");
            throw new LockedException("Account is inactive. Contact support.");
        }

        if (user.getStatus() == 2) {
            logFailure(user, ipAddress, userAgent, "Account suspended");
            throw new LockedException("Account is suspended. Contact support.");
        }

        if (isAccountLocked(user)) {
            logFailure(user, ipAddress, userAgent, "Account locked due to too many failed attempts");
            throw new LockedException("Account is locked due to too many failed login attempts. Try again after 30 minutes.");
        }

        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            incrementFailedAttempts(user);
            logFailure(user, ipAddress, userAgent, "Invalid password");
            throw new BadCredentialsException("Invalid username or password");
        }

        resetFailedAttempts(user);

        UUID sessionId = UUID.randomUUID();
        OffsetDateTime now = OffsetDateTime.now();

        UserSession session = new UserSession();
        session.setSessionId(sessionId);
        session.setUserId(user.getUserId());
        session.setIpAddress(ipAddress);
        session.setUserAgent(userAgent);
        session.setLoginTime(now);
        session.setLastActivityAt(now);
        session.setExpiresAt(now.plusMinutes(60));
        userSessionRepository.save(session);

        String accessToken = jwtService.generateToken(user.getUserId(), user.getUsername(), user.getStatus());

        logSuccess(user, ipAddress, userAgent);

        return new LoginResponse(accessToken, jwtService.getExpirationMs() / 1000, sessionId);
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void incrementFailedAttempts(User user) {
        User freshUser = userRepository.findById(user.getUserId()).orElseThrow();
        short attempts = (short) (freshUser.getFailedLoginAttempts() + 1);
        freshUser.setFailedLoginAttempts(attempts);
        if (attempts >= MAX_FAILED_ATTEMPTS) {
            freshUser.setAccountLockedUntil(OffsetDateTime.now().plusMinutes(LOCK_DURATION_MINUTES));
        }
        userRepository.save(freshUser);
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void resetFailedAttempts(User user) {
        User freshUser = userRepository.findById(user.getUserId()).orElseThrow();
        freshUser.setFailedLoginAttempts((short) 0);
        freshUser.setAccountLockedUntil(null);
        userRepository.save(freshUser);
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void logSuccess(User user, String ipAddress, String userAgent) {
        LoginHistory log = new LoginHistory();
        log.setUserId(user.getUserId());
        log.setIpAddress(ipAddress);
        log.setUserAgent(userAgent);
        log.setLoginMethod("password");
        log.setLoginTime(OffsetDateTime.now());
        log.setStatus((short) 1);
        loginHistoryRepository.save(log);
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void logFailure(User user, String ipAddress, String userAgent, String reason) {
        LoginHistory log = new LoginHistory();
        log.setUserId(user.getUserId());
        log.setIpAddress(ipAddress);
        log.setUserAgent(userAgent);
        log.setLoginMethod("password");
        log.setLoginTime(OffsetDateTime.now());
        log.setStatus((short) 0);
        log.setFailureReason(reason);
        loginHistoryRepository.save(log);
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void logFailureNoUser(String username, String ipAddress, String userAgent, String reason) {
        LoginHistory log = new LoginHistory();
        log.setUserId(0);
        log.setIpAddress(ipAddress);
        log.setUserAgent(userAgent);
        log.setLoginMethod("password");
        log.setLoginTime(OffsetDateTime.now());
        log.setStatus((short) 0);
        log.setFailureReason(reason + " - username: " + username);
        loginHistoryRepository.save(log);
    }

    private boolean isAccountLocked(User user) {
        if (user.getAccountLockedUntil() == null) {
            return false;
        }
        if (OffsetDateTime.now().isAfter(user.getAccountLockedUntil())) {
            resetFailedAttempts(user);
            return false;
        }
        return true;
    }
}