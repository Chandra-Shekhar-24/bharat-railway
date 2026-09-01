/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-backend
 * Branch: feature/backend-developer-hitanshu
 * Developer: Chandra Shekhar Bansal
 * Assisted by: DeepSeek (AI Scribe)
 * Date: 2026-09-01
 * Version: 0.1.0-SNAPSHOT
 *
 * Description:
 * JPA Entity mapped to financial_schema.refund_approval_rules.
 */

package com.bharatrailway.financial.domain;

import java.math.BigDecimal;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(schema = "financial_schema", name = "refund_approval_rules")
public class RefundApprovalRule {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "rule_id")
    private Integer ruleId;

    @Column(name = "rule_name", length = 100, nullable = false)
    private String ruleName;

    @Column(name = "refund_scenario", length = 30, nullable = false)
    private String refundScenario;

    @Column(name = "refund_amount_min", precision = 10, scale = 2, nullable = false)
    private BigDecimal refundAmountMin;

    @Column(name = "refund_amount_max", precision = 10, scale = 2, nullable = false)
    private BigDecimal refundAmountMax;

    @Column(name = "approval_level", nullable = false)
    private Short approvalLevel;

    @Column(name = "auto_approve", nullable = false)
    private Boolean autoApprove;

    @Column(name = "requires_documentation", nullable = false)
    private Boolean requiresDocumentation;

    @Column(name = "processing_time_hours", nullable = false)
    private Short processingTimeHours;

    public RefundApprovalRule() {
    }

    public Integer getRuleId() {
        return ruleId;
    }

    public void setRuleId(Integer ruleId) {
        this.ruleId = ruleId;
    }

    public String getRuleName() {
        return ruleName;
    }

    public void setRuleName(String ruleName) {
        this.ruleName = ruleName;
    }

    public String getRefundScenario() {
        return refundScenario;
    }

    public void setRefundScenario(String refundScenario) {
        this.refundScenario = refundScenario;
    }

    public BigDecimal getRefundAmountMin() {
        return refundAmountMin;
    }

    public void setRefundAmountMin(BigDecimal refundAmountMin) {
        this.refundAmountMin = refundAmountMin;
    }

    public BigDecimal getRefundAmountMax() {
        return refundAmountMax;
    }

    public void setRefundAmountMax(BigDecimal refundAmountMax) {
        this.refundAmountMax = refundAmountMax;
    }

    public Short getApprovalLevel() {
        return approvalLevel;
    }

    public void setApprovalLevel(Short approvalLevel) {
        this.approvalLevel = approvalLevel;
    }

    public Boolean getAutoApprove() {
        return autoApprove;
    }

    public void setAutoApprove(Boolean autoApprove) {
        this.autoApprove = autoApprove;
    }

    public Boolean getRequiresDocumentation() {
        return requiresDocumentation;
    }

    public void setRequiresDocumentation(Boolean requiresDocumentation) {
        this.requiresDocumentation = requiresDocumentation;
    }

    public Short getProcessingTimeHours() {
        return processingTimeHours;
    }

    public void setProcessingTimeHours(Short processingTimeHours) {
        this.processingTimeHours = processingTimeHours;
    }
}