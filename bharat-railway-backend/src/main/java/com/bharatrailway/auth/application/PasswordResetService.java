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
 * Password reset service. Token stored as raw UUID for direct lookup.
 * Published to Kafka for notification service consumption.
 */

package com.bharatrailway.auth.application;

import java.time.OffsetDateTime;
import java.util.UUID;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bharatrailway.auth.domain.PasswordResetToken;
import com.bharatrailway.auth.infrastructure.PasswordResetTokenRepository;
import com.bharatrailway.auth.infrastructure.kafka.NotificationEvent;
import com.bharatrailway.auth.infrastructure.kafka.NotificationEventPublisher;
import com.bharatrailway.identity.domain.User;
import com.bharatrailway.identity.infrastructure.UserRepository;

@Service
public class PasswordResetService {

    private static final long TOKEN_EXPIRY_MINUTES = 15;

    private final UserRepository userRepository;
    private final PasswordResetTokenRepository passwordResetTokenRepository;
    private final NotificationEventPublisher notificationEventPublisher;
    private final BCryptPasswordEncoder passwordEncoder;

    public PasswordResetService(UserRepository userRepository,
                                PasswordResetTokenRepository passwordResetTokenRepository,
                                NotificationEventPublisher notificationEventPublisher,
                                BCryptPasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordResetTokenRepository = passwordResetTokenRepository;
        this.notificationEventPublisher = notificationEventPublisher;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public void initiateReset(String email, String channel, String ipAddress) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("If the email exists, a reset link has been sent"));

        String rawToken = UUID.randomUUID().toString() + "-" + UUID.randomUUID().toString();

        PasswordResetToken resetToken = new PasswordResetToken();
        resetToken.setUserId(user.getUserId());
        resetToken.setToken(rawToken);
        resetToken.setRequestIp(ipAddress);
        resetToken.setResetChannel(channel);
        resetToken.setIsUsed(false);
        resetToken.setCreatedAt(OffsetDateTime.now());
        resetToken.setExpiresAt(OffsetDateTime.now().plusMinutes(TOKEN_EXPIRY_MINUTES));
        passwordResetTokenRepository.save(resetToken);

        NotificationEvent event = new NotificationEvent(
                user.getUserId(),
                user.getEmail(),
                rawToken,
                channel
        );
        notificationEventPublisher.publishPasswordReset(event);
    }

    @Transactional
    public void resetPassword(String token, String newPassword) {
        PasswordResetToken resetToken = passwordResetTokenRepository.findByToken(token)
                .orElseThrow(() -> new RuntimeException("Invalid or expired reset token"));

        if (resetToken.getIsUsed()) {
            throw new RuntimeException("Reset token has already been used");
        }

        if (OffsetDateTime.now().isAfter(resetToken.getExpiresAt())) {
            throw new RuntimeException("Reset token has expired");
        }

        User user = userRepository.findById(resetToken.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setPasswordHash(passwordEncoder.encode(newPassword));
        user.setFailedLoginAttempts((short) 0);
        user.setAccountLockedUntil(null);
        userRepository.save(user);

        resetToken.setIsUsed(true);
        passwordResetTokenRepository.save(resetToken);
    }
}