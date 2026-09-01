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
 * Application service for Financial domain.
 * Handles transaction ledger, bank reconciliation, and refund rules.
 */

package com.bharatrailway.financial.application.service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bharatrailway.financial.domain.BankReconciliation;
import com.bharatrailway.financial.domain.RefundApprovalRule;
import com.bharatrailway.financial.domain.TransactionLedger;
import com.bharatrailway.financial.infrastructure.BankReconciliationRepository;
import com.bharatrailway.financial.infrastructure.RefundApprovalRuleRepository;
import com.bharatrailway.financial.infrastructure.TransactionLedgerRepository;

@Service
public class FinancialService {

    private final TransactionLedgerRepository ledgerRepository;
    private final BankReconciliationRepository reconciliationRepository;
    private final RefundApprovalRuleRepository ruleRepository;

    public FinancialService(TransactionLedgerRepository ledgerRepository,
                            BankReconciliationRepository reconciliationRepository,
                            RefundApprovalRuleRepository ruleRepository) {
        this.ledgerRepository = ledgerRepository;
        this.reconciliationRepository = reconciliationRepository;
        this.ruleRepository = ruleRepository;
    }

    @Transactional
    public TransactionLedger recordTransaction(String pnrNumber, Integer bookingId,
                                                String transactionType, String financialYear,
                                                String accountingPeriod, BigDecimal amount,
                                                String debitAccount, String creditAccount,
                                                String paymentMethod) {
        TransactionLedger ledger = new TransactionLedger();
        ledger.setTransactionNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        ledger.setPnrNumber(pnrNumber);
        ledger.setBookingId(bookingId);
        ledger.setTransactionType(transactionType);
        ledger.setTransactionDate(LocalDate.now());
        ledger.setTransactionTimestamp(OffsetDateTime.now());
        ledger.setFinancialYear(financialYear);
        ledger.setAccountingPeriod(accountingPeriod);
        ledger.setDebitAccountCode(debitAccount);
        ledger.setCreditAccountCode(creditAccount);
        ledger.setTransactionAmount(amount);
        ledger.setPaymentMethod(paymentMethod);
        ledger.setCreatedAt(OffsetDateTime.now());
        return ledgerRepository.save(ledger);
    }

    public List<TransactionLedger> getLedgerByPnr(String pnrNumber) {
        return ledgerRepository.findByPnrNumber(pnrNumber);
    }

    public List<TransactionLedger> getLedgerByType(String transactionType) {
        return ledgerRepository.findByTransactionType(transactionType);
    }

    public List<TransactionLedger> getLedgerByYear(String financialYear) {
        return ledgerRepository.findByFinancialYear(financialYear);
    }

    @Transactional
    public BankReconciliation createReconciliation(String bankAccountCode,
                                                     BigDecimal openingBook, BigDecimal closingBook,
                                                     BigDecimal openingBank, BigDecimal closingBank) {
        BankReconciliation reconciliation = new BankReconciliation();
        reconciliation.setReconciliationDate(LocalDate.now());
        reconciliation.setBankAccountCode(bankAccountCode);
        reconciliation.setOpeningBalanceBook(openingBook);
        reconciliation.setClosingBalanceBook(closingBook);
        reconciliation.setOpeningBalanceBank(openingBank);
        reconciliation.setClosingBalanceBank(closingBank);
        reconciliation.setUnreconciledAmount(closingBank.subtract(closingBook).abs());
        return reconciliationRepository.save(reconciliation);
    }

    public List<BankReconciliation> getReconciliationsByAccount(String bankAccountCode) {
        return reconciliationRepository.findByBankAccountCode(bankAccountCode);
    }

    @Transactional
    public RefundApprovalRule createRule(RefundApprovalRule rule) {
        return ruleRepository.save(rule);
    }

    public List<RefundApprovalRule> getRulesByScenario(String refundScenario) {
        return ruleRepository.findByRefundScenario(refundScenario);
    }

    public List<RefundApprovalRule> getAutoApproveRules() {
        return ruleRepository.findByAutoApproveTrue();
    }
}