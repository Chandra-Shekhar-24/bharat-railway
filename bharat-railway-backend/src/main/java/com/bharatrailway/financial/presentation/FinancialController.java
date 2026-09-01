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
 * REST controller for Financial domain.
 * Provides endpoints for ledger, reconciliation, and refund rules.
 */

package com.bharatrailway.financial.presentation;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bharatrailway.financial.application.service.FinancialService;
import com.bharatrailway.financial.domain.BankReconciliation;
import com.bharatrailway.financial.domain.RefundApprovalRule;
import com.bharatrailway.financial.domain.TransactionLedger;

@RestController
@RequestMapping("/api/v1/financial")
public class FinancialController {

    private final FinancialService financialService;

    public FinancialController(FinancialService financialService) {
        this.financialService = financialService;
    }

    @PostMapping("/ledger")
    public ResponseEntity<TransactionLedger> recordTransaction(
            @RequestBody Map<String, Object> request) {
        String pnrNumber = (String) request.get("pnrNumber");
        Integer bookingId = request.get("bookingId") != null ? (Integer) request.get("bookingId") : null;
        String transactionType = (String) request.get("transactionType");
        String financialYear = (String) request.get("financialYear");
        String accountingPeriod = (String) request.get("accountingPeriod");
        BigDecimal amount = new BigDecimal(request.get("amount").toString());
        String debitAccount = (String) request.get("debitAccount");
        String creditAccount = (String) request.get("creditAccount");
        String paymentMethod = (String) request.get("paymentMethod");

        TransactionLedger ledger = financialService.recordTransaction(
                pnrNumber, bookingId, transactionType, financialYear,
                accountingPeriod, amount, debitAccount, creditAccount, paymentMethod);
        return ResponseEntity.status(HttpStatus.CREATED).body(ledger);
    }

    @GetMapping("/ledger/pnr/{pnrNumber}")
    public ResponseEntity<List<TransactionLedger>> getLedgerByPnr(@PathVariable String pnrNumber) {
        return ResponseEntity.ok(financialService.getLedgerByPnr(pnrNumber));
    }

    @GetMapping("/ledger/type/{transactionType}")
    public ResponseEntity<List<TransactionLedger>> getLedgerByType(@PathVariable String transactionType) {
        return ResponseEntity.ok(financialService.getLedgerByType(transactionType));
    }

    @GetMapping("/ledger/year/{financialYear}")
    public ResponseEntity<List<TransactionLedger>> getLedgerByYear(@PathVariable String financialYear) {
        return ResponseEntity.ok(financialService.getLedgerByYear(financialYear));
    }

    @PostMapping("/reconciliation")
    public ResponseEntity<BankReconciliation> createReconciliation(
            @RequestBody Map<String, Object> request) {
        String bankAccountCode = (String) request.get("bankAccountCode");
        BigDecimal openingBook = new BigDecimal(request.get("openingBalanceBook").toString());
        BigDecimal closingBook = new BigDecimal(request.get("closingBalanceBook").toString());
        BigDecimal openingBank = new BigDecimal(request.get("openingBalanceBank").toString());
        BigDecimal closingBank = new BigDecimal(request.get("closingBalanceBank").toString());

        BankReconciliation reconciliation = financialService.createReconciliation(
                bankAccountCode, openingBook, closingBook, openingBank, closingBank);
        return ResponseEntity.status(HttpStatus.CREATED).body(reconciliation);
    }

    @PostMapping("/refund-rules")
    public ResponseEntity<RefundApprovalRule> createRule(@RequestBody RefundApprovalRule rule) {
        RefundApprovalRule created = financialService.createRule(rule);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @GetMapping("/refund-rules/scenario/{refundScenario}")
    public ResponseEntity<List<RefundApprovalRule>> getRulesByScenario(@PathVariable String refundScenario) {
        return ResponseEntity.ok(financialService.getRulesByScenario(refundScenario));
    }
}