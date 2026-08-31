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
 * Password reset service. Generates a 6-digit OTP stored as raw string.
 * OTP is sent via email (Spring Mail) for immediate user notification.
 * Kafka event published for future notification service consumption.
 * OTP is single-use and expires in 15 minutes.
 */

package com.bharatrailway.auth.application;

import java.security.SecureRandom;
import java.time.OffsetDateTime;
import java.util.Random;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bharatrailway.auth.domain.PasswordResetToken;
import com.bharatrailway.auth.infrastructure.PasswordResetTokenRepository;
import com.bharatrailway.auth.infrastructure.kafka.NotificationEvent;
import com.bharatrailway.auth.infrastructure.kafka.NotificationEventPublisher;
import com.bharatrailway.identity.domain.User;
import com.bharatrailway.identity.infrastructure.UserRepository;
import com.bharatrailway.shared.infrastructure.EmailService;

@Service
public class PasswordResetService {

    private static final long TOKEN_EXPIRY_MINUTES = 15;

    private final UserRepository userRepository;
    private final PasswordResetTokenRepository passwordResetTokenRepository;
    private final NotificationEventPublisher notificationEventPublisher;
    private final BCryptPasswordEncoder passwordEncoder;
    private final EmailService emailService;

    public PasswordResetService(UserRepository userRepository,
                                PasswordResetTokenRepository passwordResetTokenRepository,
                                NotificationEventPublisher notificationEventPublisher,
                                BCryptPasswordEncoder passwordEncoder,
                                EmailService emailService) {
        this.userRepository = userRepository;
        this.passwordResetTokenRepository = passwordResetTokenRepository;
        this.notificationEventPublisher = notificationEventPublisher;
        this.passwordEncoder = passwordEncoder;
        this.emailService = emailService;
    }

    @Transactional
    public void initiateReset(String email, String channel, String ipAddress) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("If the email exists, a reset link has been sent"));

        String otp = generateSixDigitOtp();

        PasswordResetToken resetToken = new PasswordResetToken();
        resetToken.setUserId(user.getUserId());
        resetToken.setToken(otp); // stored directly, no hashing for single-use OTP
        resetToken.setRequestIp(ipAddress);
        resetToken.setResetChannel(channel);
        resetToken.setIsUsed(false);
        resetToken.setCreatedAt(OffsetDateTime.now());
        resetToken.setExpiresAt(OffsetDateTime.now().plusMinutes(TOKEN_EXPIRY_MINUTES));
        passwordResetTokenRepository.save(resetToken);

        NotificationEvent event = new NotificationEvent(
                user.getUserId(),
                user.getEmail(),
                otp,
                channel
        );
        notificationEventPublisher.publishPasswordReset(event);

        // Send email directly - failure does not rollback token creation
        try {
            emailService.sendEmail(
                user.getEmail(),
                "Password Reset OTP - Bharat Railway",
                "Your password reset OTP: " + otp + "\n\nThis OTP is valid for 15 minutes."
            );
        } catch (Exception e) {
            // Email failed, but token is already saved and Kafka event published
        }
    }

    @Transactional
    public void resetPassword(String otp, String newPassword) {
        PasswordResetToken resetToken = passwordResetTokenRepository.findByToken(otp)
                .orElseThrow(() -> new RuntimeException("Invalid or expired OTP"));

        if (resetToken.getIsUsed()) {
            throw new RuntimeException("OTP has already been used");
        }

        if (OffsetDateTime.now().isAfter(resetToken.getExpiresAt())) {
            throw new RuntimeException("OTP has expired");
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

    private String generateSixDigitOtp() {
        Random random = new SecureRandom();
        int otp = 100000 + random.nextInt(900000); // 100000 to 999999
        return String.valueOf(otp);
    }
}