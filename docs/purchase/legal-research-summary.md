# AXPONA Acquisition: Legal Research Summary

> **Date:** 2026-03-17
> **Issue:** [research-pr#46](https://github.com/timjmitchell/research-pr/issues/46)
> **Disclaimer:** Legal research only, not legal advice. Consult qualified counsel.

---

## Deal Overview

| | |
|---|---|
| **Target** | AXPONA (Audio Expo North America) — annual trade show, owned by JD Events, LLC |
| **Transaction** | Asset purchase (not equity) |
| **Seller** | JD Events, LLC (Delaware LLC) |
| **Buyer** | New acquiring LLC with multiple members |
| **Majority Partner** | Prim (C-Corp or LLC) |
| **Minority Equity** | Carcross Capital LP — Henry's (Carcross) Delaware LP, passive equity (% profit + % equity, no salary) |
| **EBITDA** | $782K (2025 actual), $943K (2026 forecast) |
| **Likely Price Range** | $2.3M–$4.7M (3–5x EBITDA for single trade show) |
| **Structure** | 95% at close, 5% escrow (12 months), Net Deposits adjustment |
| **Key Assets** | Brand/trademarks, databases, website, venue contracts (through 2029), event dates |
| **Employees** | 3 in Connecticut — hired by buyer (new offer letters, not transferred) |

---

## Key Recommendations

### 1. Form Carcross Capital LP in Delaware

- GP LLC (Henry (Carcross), sole member) + Henry (Carcross) as sole LP
- **Never serve as GP directly** — use LLC for liability shielding
- Delaware: best case law, maximum contractual freedom, $300/yr flat franchise tax, exclusive charging order protection
- No foreign qualification needed for the LP itself (passive holding vehicle)
- Total formation cost: ~$290 one-time, ~$600/yr ongoing

### 2. Acquiring Entity: C-Corp vs. LLC — Depends on Exit Timeline

| Scenario | Recommendation | Why |
|----------|---------------|-----|
| **Exit in 5–7 years** | **C-Corp** (or LLC electing C-Corp via Form 8832) | QSBS Section 1202 exclusion: potentially $0 federal tax on up to $15M in capital gains per investor |
| **Hold forever, distribute cash** | **LLC (pass-through)** | ~$106K/year more to investors via pass-through + Section 199A |
| **Retain earnings for growth** | **C-Corp** | 21% retention rate vs. forced tax distributions in LLC |

**Recommended implementation:** Form a Delaware LLC, then elect C-Corp taxation if QSBS path is chosen. Gets LLC governance flexibility with C-Corp tax treatment.

**This is primarily Prim's decision** as majority partner. Henry (Carcross) can advocate.

### 3. Idaho Domicile Strongly Preferred Over California

| Factor | Idaho | California | Delta |
|--------|-------|------------|-------|
| Income tax rate | 5.695% flat | Up to 13.3% | +7.6 points |
| QSBS conformity | **Yes** | **No** | Up to $1.33M on $10M gain |
| Section 199A conformity | Yes | No | CA pays more |
| LP franchise tax | $0 | $800/yr | $800/yr |
| 5-year total (on $1M/yr + $10M exit w/QSBS) | **~$37,500** | **~$1,701,600** | **~$1.66M** |

### 4. APA: Highest-Risk Items

| Risk | Severity | Mitigation |
|------|----------|------------|
| **Venue refuses assignment consent** | High | Engage Renaissance Schaumburg early; make consent a closing condition |
| **Key employees don't accept offers** | High | Competitive offers + retention bonuses; make acceptance a closing condition |
| **Illinois bulk sale withholding** | Medium | Notify IL Dept of Revenue 10+ business days before close; request seller tax clearance |
| **Deferred revenue timing** | Medium | Careful Net Deposits calculation; consider closing timing relative to April event |

### 5. Non-Compete for Seller

- 3–5 years, national scope, covering audio/hi-fi trade shows
- FTC non-compete rule is NOT in effect (enjoined, appeals dismissed Sept 2025)
- Business-sale non-competes remain enforceable under state law

---

## Open Questions

These must be resolved before drafting the agreements:

### Deal Structure

| Question | Impacts | Who Decides |
|----------|---------|-------------|
| **C-Corp or LLC for acquiring entity?** | Tax treatment, QSBS eligibility, distribution mechanics, investor reporting | Prim + Henry (Carcross) |
| **What is Henry's (Carcross) equity %?** | LP agreement, LLC operating agreement, distribution amounts | Negotiation with Prim |
| **What EBITDA multiple?** | Purchase price, escrow amount, all financial terms | Negotiation with seller |
| **Close before or after April 10 event?** | Price basis ($782K vs $943K EBITDA), Net Deposits amount, deferred revenue risk | Buyer + seller |
| **Will Prim operate the business, or is operations TBD?** | LLC operating agreement management provisions, TSA scope | Prim |

### Henry (Carcross) Specifics

| Question | Impacts | Notes |
|----------|---------|-------|
| **Is Henry (Carcross) domiciled in CA or ID?** | State income tax, QSBS benefit, LP registration, annual franchise tax | ~$1.66M difference over 5 years |
| **What is Henry's (Carcross) operational role?** | LLC operating agreement (duties, authority, board seat, expense reimbursement) | No salary confirmed; equity-only compensation |
| **Will Carcross Capital LP ever have outside investors?** | Securities law (Reg D), LP agreement complexity, waterfall, reporting | Currently no; Scenario B documented if this changes |
| **Desired hold period?** | C-Corp vs LLC decision, QSBS planning (need 5+ years for 100% exclusion) | Drives entity structure recommendation |

### Legal/Structural

| Question | Impacts | Notes |
|----------|---------|-------|
| **Confirm QSBS eligibility for trade show business** | Entire C-Corp thesis | Likely qualifies but no direct IRS ruling — need tax counsel opinion |
| **Is the LP treated as disregarded for tax purposes?** | Whether LP files Form 1065 or reports on Henry's (Carcross) personal return | GP LLC (single-member) + Henry (Carcross) (sole LP) may = single tax owner |
| **Venue contract assignment terms** | Closing condition, deal risk | Must review actual Renaissance Schaumburg contracts |
| **Seller's tax clearance from Illinois** | Bulk sale compliance, buyer liability for seller's unpaid taxes | File notice 10+ business days before close |

---

## Entity Structure

```
Acquiring LLC (buys AXPONA)
  │
  ├── Prim (C-Corp or LLC) — majority partner
  │
  ├── Carcross Capital LP — minority equity member (% profit + % equity)
  │     ├── GP: Carcross Capital GP LLC (DE LLC, Henry (Carcross), sole member)
  │     └── LP: Henry (Carcross) (sole limited partner)
  │
  └── Other Members (if any)
```

---

## Jurisdiction Matrix (Carcross Capital LP)

| Factor | Delaware | Illinois | Idaho | California |
|--------|----------|----------|-------|------------|
| Role | LP formation | AXPONA operations | Domicile (option) | Domicile (option) |
| Income tax | None | 4.95% (source) | 5.695% flat | Up to 13.3% |
| Capital gains | N/A | 4.95% | 5.695% | 13.3% |
| QSBS conformity | N/A | Yes | **Yes** | **No** |
| Section 199A | N/A | Yes | Yes | No |
| LP entity tax | $300/yr | N/A | $0 | $800/yr |
| Charging order | Exclusive remedy | N/A | Exclusive remedy | Foreclosure possible |

---

## Financial Comparison: C-Corp vs. LLC (Annual, $900K EBITDA)

| | C-Corp | LLC (Pass-Through) |
|---|---|---|
| Entity tax | $189K (21%) | $0 |
| Distribution/dividend tax | $169K (23.8% on $711K) | N/A |
| Individual tax (with 199A) | N/A | $252K (28% effective) |
| **Total tax** | **$358K** | **$252K** |
| **Net to investors** | **$542K** | **$648K** |
| Annual advantage | — | +$106K/yr |
| **Exit tax on $10M gain (QSBS, 5+ yr)** | **$0** | **~$2.4M** |

---

## Research Documents

| Document | Contents |
|----------|----------|
| [legal-research-apa.md](legal-research-apa.md) | APA structure, asset definitions, purchase price mechanics, reps/warranties, employee matters, contract assignment, IP transfer, non-compete, TSA, escrow, indemnification, closing conditions, Illinois bulk sale, tax implications |
| [legal-research-ccorp-vs-llc.md](legal-research-ccorp-vs-llc.md) | C-Corp vs LLC comparison, QSBS Section 1202 deep dive, tax modeling, investor considerations, exit analysis, hybrid approaches |
| [legal-research-feeder-fund.md](legal-research-feeder-fund.md) | Carcross Capital LP structure (Scenario A: Henry (Carcross) only; Scenario B: with investors), formation, LP agreement provisions, regulatory considerations, jurisdiction analysis (DE/IL/ID/CA matrix) |

---

## Next Steps

1. **Resolve open questions** above — especially domicile, equity %, EBITDA multiple, and C-Corp vs LLC
2. **Draft Asset Purchase Agreement** using deal terms from the Offering Memorandum
3. **Draft Carcross Capital LP Partnership Agreement** (Scenario A; extensible to B)
4. **Obtain tax counsel opinion** on QSBS eligibility for trade show business
5. **Review actual venue contracts** for assignment provisions
