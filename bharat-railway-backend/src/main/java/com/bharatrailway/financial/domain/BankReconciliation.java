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
 * JPA Entity mapped to financial_schema.bank_reconciliation.
 */

package com.bharatrailway.financial.domain;

import java.math.BigDecimal;
import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(schema = "financial_schema", name = "bank_reconciliation")
public class BankReconciliation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "reconciliation_id")
    private Integer reconciliationId;

    @Column(name = "reconciliation_date", nullable = false)
    private LocalDate reconciliationDate;

    @Column(name = "bank_account_code", length = 20, nullable = false)
    private String bankAccountCode;

    @Column(name = "opening_balance_book", precision = 15, scale = 2, nullable = false)
    private BigDecimal openingBalanceBook;

    @Column(name = "closing_balance_book", precision = 15, scale = 2, nullable = false)
    private BigDecimal closingBalanceBook;

    @Column(name = "opening_balance_bank", precision = 15, scale = 2, nullable = false)
    private BigDecimal openingBalanceBank;

    @Column(name = "closing_balance_bank", precision = 15, scale = 2, nullable = false)
    private BigDecimal closingBalanceBank;

    @Column(name = "unreconciled_amount", precision = 15, scale = 2, nullable = false)
    private BigDecimal unreconciledAmount;

    public BankReconciliation() {
    }

    public Integer getReconciliationId() {
        return reconciliationId;
    }

    public void setReconciliationId(Integer reconciliationId) {
        this.reconciliationId = reconciliationId;
    }

    public LocalDate getReconciliationDate() {
        return reconciliationDate;
    }

    public void setReconciliationDate(LocalDate reconciliationDate) {
        this.reconciliationDate = reconciliationDate;
    }

    public String getBankAccountCode() {
        return bankAccountCode;
    }

    public void setBankAccountCode(String bankAccountCode) {
        this.bankAccountCode = bankAccountCode;
    }

    public BigDecimal getOpeningBalanceBook() {
        return openingBalanceBook;
    }

    public void setOpeningBalanceBook(BigDecimal openingBalanceBook) {
        this.openingBalanceBook = openingBalanceBook;
    }

    public BigDecimal getClosingBalanceBook() {
        return closingBalanceBook;
    }

    public void setClosingBalanceBook(BigDecimal closingBalanceBook) {
        this.closingBalanceBook = closingBalanceBook;
    }

    public BigDecimal getOpeningBalanceBank() {
        return openingBalanceBank;
    }

    public void setOpeningBalanceBank(BigDecimal openingBalanceBank) {
        this.openingBalanceBank = openingBalanceBank;
    }

    public BigDecimal getClosingBalanceBank() {
        return closingBalanceBank;
    }

    public void setClosingBalanceBank(BigDecimal closingBalanceBank) {
        this.closingBalanceBank = closingBalanceBank;
    }

    public BigDecimal getUnreconciledAmount() {
        return unreconciledAmount;
    }

    public void setUnreconciledAmount(BigDecimal unreconciledAmount) {
        this.unreconciledAmount = unreconciledAmount;
    }
}