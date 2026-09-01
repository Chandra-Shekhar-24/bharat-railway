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
 * Spring Data JPA repository for financial_schema.bank_reconciliation.
 */

package com.bharatrailway.financial.infrastructure;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.bharatrailway.financial.domain.BankReconciliation;

@Repository
public interface BankReconciliationRepository extends JpaRepository<BankReconciliation, Integer> {

    List<BankReconciliation> findByBankAccountCode(String bankAccountCode);
}