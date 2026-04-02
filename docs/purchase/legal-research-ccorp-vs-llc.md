# C-Corporation vs. LLC: Acquiring Entity Structure Analysis

> **Date:** 2026-03-17
> **Issue:** [research-pr#46](https://github.com/timjmitchell/research-pr/issues/46)
> **Context:** AXPONA asset purchase, ~$3-6M deal, $782K-$943K EBITDA, 13-15% annual growth
> **Parties:** Prim (majority partner, C-Corp or LLC) + Carcross Capital LP (minority equity, Henry's (Carcross) LP) = members of acquiring LLC
> **Note:** The acquiring entity structure is primarily Prim's decision as majority partner. This analysis informs Carcross Capital's position in negotiations and the impact on Henry's (Carcross) returns.
> **Disclaimer:** Legal research only, not legal advice. Consult qualified counsel before proceeding.

---

## TL;DR

| Scenario | Winner | Why |
|----------|--------|-----|
| Exit in 5-7 years | **C-Corp** | QSBS exclusion saves $2-5M+ in federal capital gains tax |
| Hold forever, distribute cash | **LLC** | ~$106K/year more to investors via pass-through + Section 199A |
| Retain earnings for growth | **C-Corp** | 21% retention rate vs. forced ~$350K/year tax distributions in LLC |
| Waterfall/carry flexibility | **LLC** | Industry-standard PE economics; C-Corp requires workarounds |

**Recommended structure:** Delaware LLC electing C-Corp taxation (check-the-box) — gets LLC governance flexibility with C-Corp tax treatment and QSBS eligibility.

---

## 1. Tax Treatment Comparison

### Federal Rates

| Factor | C-Corporation | LLC (Pass-Through) |
|--------|--------------|-------------------|
| Entity-level tax | 21% federal flat | None |
| Distribution tax | 15-20% qualified dividend + 3.8% NIIT | Taxed once at individual rates (up to 37% + 3.8% NIIT) |
| Effective combined rate (distributed) | ~39.8% | ~28% (with Section 199A) |
| Section 199A QBI deduction | Not available | Up to 20% deduction on QBI |

### Annual Tax on $900K EBITDA (Fully Distributed)

**C-Corp:**
- Corporate tax: $900K x 21% = $189K
- Qualified dividend tax: $711K x 23.8% = $169K
- **Total tax: ~$358K (39.8% effective)**
- **Net to investors: ~$542K**

**LLC (pass-through with 199A):**
- QBI deduction: $900K x 20% = $180K deduction
- Taxable QBI: $720K at ~35% blended = $252K
- **Total tax: ~$252K (28% effective)**
- **Net to investors: ~$648K**

**Annual difference: ~$106K/year more to investors in LLC structure.**

### Section 199A Eligibility

AXPONA is **likely eligible** — event/trade show business is NOT a "specified service trade or business" (SSTB). Made permanent by OBBBA (July 2025). Phase-out above ~$200K single / $400K MFJ income — investors with high outside income may see reduced benefit.

### Section 197 Amortization (Major Factor)

In a $3-6M asset purchase, most of the price allocates to goodwill and intangibles (15-year amortization):

- **LLC:** ~$200K-$400K/year in amortization deductions flow directly to investors on K-1s
- **C-Corp:** Same amortization only reduces corporate income at 21% rate; investors don't benefit directly

On a $4.5M purchase: ~$300K/year in amortization worth 37 cents/dollar to investors in LLC vs. 21 cents/dollar in C-Corp.

### Retained Earnings

- **C-Corp:** Retains at 21% federal + 9.5% Illinois = ~30.5% combined. No additional tax until distributed.
- **LLC:** Investors owe tax on allocated income even without distributions. Forces ~$312K-$424K/year in mandatory tax distributions.

**If reinvesting most EBITDA, C-Corp preserves more capital.** But beware the Accumulated Earnings Tax (20% penalty) if retention exceeds "reasonable business needs."

### State Taxes

| Tax | C-Corporation | LLC |
|-----|--------------|-----|
| Delaware franchise tax | $175-$200K+ (shares/capital method) | Flat $300/year |
| Illinois corporate income | 9.5% (7% + 2.5% replacement) | 2.5% replacement tax only |
| Illinois franchise tax | Yes (paid-in capital) | N/A |

**Note on Delaware franchise tax:** The authorized shares method can produce very high taxes for C-Corps. The alternative "assumed par value capital" method typically yields a much lower number. Must be calculated carefully at formation. This can be managed to ~$400-$2,000/year with proper structuring (low authorized shares, high par value).

---

## 2. QSBS Deep Dive (Section 1202) — The C-Corp's Ace

### Post-OBBBA Requirements (July 2025)

| Requirement | AXPONA Status |
|-------------|---------------|
| Domestic C-Corporation | Must elect (or form as) C-Corp |
| Gross assets <= **$75M** (raised from $50M) | At $3-6M, well under threshold |
| Original issuance to investors | Stock issued at formation — satisfied |
| Active business (80%+ of assets) | Trade show = active business |
| Not an excluded business | See analysis below |
| Holding period | Tiered: 50% @ 3yr, 75% @ 4yr, **100% @ 5yr** (new under OBBBA) |
| Per-issuer gain cap | **$15M** or 10x basis (raised from $10M) |

### Does a Trade Show Qualify?

**Excluded businesses:** Professional services, banking, farming, mining, **hotels/motels/restaurants/similar**.

**AXPONA is likely eligible:**
- NOT professional services — sells exhibit space, sponsorships, tickets
- NOT hospitality — does not operate lodging or food service; rents convention space
- "Similar business" language interpreted narrowly by IRS
- Principal asset is NOT reputation/skill of employees — it's the brand, databases, recurring format

**Caveat:** No direct IRS ruling or court case for event businesses. Tax counsel should provide formal opinion.

### QSBS Flow-Through to Feeder LP Investors

Under Section 1202(g), QSBS benefits **flow through** the feeder LP to individual investors IF:
1. Investor was an LP **at the time** the C-Corp stock was acquired
2. Exclusion limited to proportionate interest at acquisition
3. LPs joining after acquisition do NOT get QSBS on that stock
4. 5-year holding period runs from partnership's acquisition date

### Illustrative Exit Tax Savings

Assume: $4.5M acquisition → grows to $15M value in 6 years.

| | Without QSBS | With QSBS (5+ year hold) |
|---|---|---|
| Capital gain | $10.5M | $10.5M |
| Federal tax | ~$2.5M (23.8%) | **$0** (100% exclusion) |
| Savings | — | **~$2.5M** |

Each investor gets their own $15M cap. With 10 investors, aggregate exclusion capacity of $150M — far exceeding any realistic exit value.

### Critical QSBS Caveat: State Conformity

States that do **NOT** honor QSBS exclusion:
- **California** (taxes QSBS gains at full rate)
- Pennsylvania, Mississippi, Alabama

**If Carcross Capital investors are in California, the QSBS benefit is reduced by the CA state tax (~13.3% on gains).** This is relevant to the CA jurisdiction check.

---

## 3. Investor and Operational Comparison

### Investor Experience

| Factor | C-Corp | LLC |
|--------|--------|-----|
| Tax reporting | 1099-DIV (simple) | K-1 (complex, multi-state filing) |
| Annual tax efficiency | Lower (~$106K/year less) | Higher |
| Exit tax efficiency | Potentially $0 with QSBS | Single tax at cap gains rates (~23.8%) |
| Phantom income risk | None | Yes (taxed on allocated income without distributions) |
| Waterfall flexibility | Limited (multiple stock classes) | Full PE-style waterfall/carry |

### Governance and Operations

| Factor | C-Corp | LLC |
|--------|--------|-----|
| Formalities | Board, officers, annual meetings, minutes | Operating agreement; minimal formalities |
| Governance flexibility | Rigid (DGCL) | Highly customizable |
| Employee equity | Stock options/RSUs (well understood) | Profits interests (less familiar) |
| Future fundraising | More familiar to institutional investors | Standard for PE structures |
| Exit marketability | Stock sale viable with QSBS | Interest sale = asset sale treatment (buyer gets step-up) |

### Exit Path Comparison

**LLC exit:** Interest sale treated as asset sale for tax → buyer gets basis step-up → single tax for seller. Very clean.

**C-Corp exit without QSBS:** Asset sale = double taxation (~39.8%); stock sale = no basis step-up for buyer (less attractive).

**C-Corp exit WITH QSBS:** Stock sale at potentially $0 federal tax → buyer doesn't get step-up but seller's tax savings may offset negotiation on price.

---

## 4. Hybrid: LLC Electing C-Corp Taxation

**This is the recommended implementation:**

- Form a **Delaware LLC** (governance flexibility, $300/year franchise tax)
- File **Form 8832** to elect C-Corp taxation
- Get: LLC operational flexibility + C-Corp tax treatment + QSBS eligibility
- Issue "units" that function like stock classes
- Avoids DGCL corporate formalities while getting QSBS

**Note:** S-Corp election is **NOT viable** — partnerships/LPs cannot be shareholders, and only one class of stock permitted.

### Conversion Strategy (Start LLC, Convert Later)

**Not recommended for this deal.** The QSBS 5-year clock restarts at conversion, and built-in gain is not excludable. Only works if hold period is 8+ years.

---

## 5. Quantitative Summary

| Metric | LLC (Pass-Through) | C-Corp (QSBS) |
|--------|-------------------|----------------|
| Annual tax on $900K EBITDA (distributed) | ~$252K (28%) | ~$358K (39.8%) |
| Annual advantage | +$106K/year | — |
| 5-year cumulative annual advantage | +$530K | — |
| Exit tax on $10M gain (after 5+ years) | ~$2.4M | $0 with QSBS |
| **Net 5-year outcome including exit** | — | **+$1.9M to C-Corp** |
| **Net 10-year outcome (no exit)** | **+$1.06M to LLC** | — |

---

## 6. Recommendation

### If exit likely within 5-7 years: **C-Corp (via LLC with check-the-box election)**

The QSBS opportunity is decisive. Potential $2.5M+ in federal tax savings at exit dwarfs the ~$100K/year annual tax advantage of pass-through.

**Implementation:**
1. Form Delaware LLC
2. Elect C-Corp taxation (Form 8832)
3. Structure multiple unit classes (common + preferred)
4. Ensure all investors in feeder LP **before** acquisition (preserves QSBS flow-through)
5. Hold minimum 5 years for 100% QSBS exclusion
6. Engage tax counsel to confirm QSBS eligibility for trade show business

### If long-term hold (10+ years), heavy distributions: **LLC (Pass-Through)**

Annual tax savings compound. Section 199A (permanent) provides 20% QBI deduction. Section 197 amortization flows to investors for 15 years. QSBS less valuable without exit event.

---

## Key Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| QSBS qualification uncertain for event businesses | High — entire C-Corp thesis depends on it | Tax counsel formal opinion |
| QSBS legislative repeal/modification | Medium | Lock in 5-year hold ASAP; diversify exit strategy |
| California doesn't honor QSBS | Medium (if CA investors) | Factor state tax into investor projections |
| Accumulated Earnings Tax | Low-Medium | Document growth reinvestment plans |
| Delaware franchise tax for C-Corp | Low | Use assumed par value method; structure authorized shares carefully |
| Section 199A phase-out for high-income investors | Low-Medium | Model per-investor based on their income |
