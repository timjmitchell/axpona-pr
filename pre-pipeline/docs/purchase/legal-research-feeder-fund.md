# Legal Research: Carcross Capital LP Structure

> **Date:** 2026-03-17
> **Issue:** [research-pr#46](https://github.com/timjmitchell/research-pr/issues/46)
> **Jurisdiction:** Delaware (primary)
> **Disclaimer:** Legal research only, not legal advice. Consult qualified securities counsel and tax advisors before proceeding.

---

## Deal Structure

**Carcross Capital LP is Henry (Carcross)'s personal investment vehicle** for holding his equity stake in the AXPONA acquisition. There are no outside investors — Henry (Carcross) is the sole limited partner, and his GP LLC is the general partner.

Carcross Capital LP:
1. Contributes capital to the acquiring LLC as one member
2. Receives a **% of profit distributions** from the acquiring LLC
3. Holds a **% of equity** (upside on a future sale)
4. Does **not** receive operating income or salary

### Entity Diagram

```
Acquiring LLC (buys AXPONA)
  │
  ├── Prim (C-Corp or LLC) — majority partner
  │
  ├── Carcross Capital LP — equity member (% profit + % equity)
  │     ├── GP: Carcross Capital GP LLC (DE LLC, Henry (Carcross), sole member)
  │     └── LP: Henry (Carcross) (sole limited partner)
  │
  └── Other Members (if any)
```

**Henry (Carcross) will likely have an operational role** in AXPONA (board seat, advisory, or active involvement) but will **not take salary** — his compensation comes entirely through his equity share (profit distributions + capital appreciation).

### Why an LP (Not Just an LLC)?

Henry (Carcross) is using an LP rather than a simple single-member LLC for his holding vehicle. Common reasons for this structure:

- **Asset protection:** In many states, LP interests have stronger charging order protection than LLC interests — creditors can obtain a charging order against distributions but cannot seize the LP interest itself or force liquidation
- **Estate planning:** LP interests can be gifted or transferred to family members with valuation discounts (lack of marketability, minority interest discounts)
- **Separation of control and economics:** GP retains full control; LP interests carry economic rights only — useful if Henry (Carcross) later brings in family or other passive participants
- **Tax flexibility:** LP provides pass-through taxation with flexibility in allocation of income, gains, and losses

### Key Implications

- **No outside investors** = no securities law concerns (no Reg D, no Form D, no accredited investor requirements)
- **No ERISA considerations** — no benefit plan investors
- **No AML/KYC requirements** — no third-party investor onboarding
- **No complex waterfall** — Henry (Carcross) receives 100% of what flows to Carcross Capital LP from the acquiring LLC
- **No investor reporting burden** — no K-1s to third parties (only Henry (Carcross)'s personal tax return)
- **Simple LP agreement** — formalizes the GP LLC / Henry (Carcross) LP relationship and the entity's purpose
- **Henry (Carcross) does not solely control the acquiring LLC** — Prim is the majority partner; Henry (Carcross) has an operational role but is primarily a capital partner
- **The C-Corp vs. LLC decision for the acquiring entity is primarily Prim's call** as majority partner. Henry (Carcross) can advocate for his preferred structure.
- **Henry (Carcross)'s unsalaried operational role** should be formalized in the acquiring LLC's operating agreement (scope of duties, authority, board/advisory seat, expense reimbursement)

---

## 1. Delaware LP Formation

### Formation Requirements

**Certificate of Limited Partnership** filed with Delaware Division of Corporations (6 Del. C. Section 17-201):
- Name of the limited partnership (Carcross Capital LP)
- Address of registered office in Delaware
- Name and address of registered agent
- Name and address of each general partner (Carcross Capital GP LLC)

**LP Agreement:** Not required to be filed but is the governing document.

**GP LLC:** Separate single-member LLC (Henry (Carcross) as sole member) serves as GP to shield Henry (Carcross)'s personal assets from the GP's unlimited liability exposure.

### Costs

| Item | Cost |
|------|------|
| Certificate of LP filing | ~$200 |
| GP LLC formation (Delaware) | ~$90 |
| Registered agent (annual, shared) | $50-$300 |
| Annual LP franchise tax | $300 (due June 1) |
| Annual GP LLC franchise tax | $300 (due June 1) |

### Registered Agent

Must maintain a **physical office** in Delaware with regular business hours (new requirement effective 2025). A single registered agent can serve both the LP and the GP LLC.

### Foreign Qualification

Carcross Capital LP likely does **not** need to foreign-qualify in any state. It is a passive holding vehicle with no employees, physical offices, or operations. Its sole activity is holding a membership interest in the acquiring LLC.

---

## 2. LP Agreement — Key Provisions

Since there are no outside investors, the LP agreement is primarily a formality that establishes the entity's governance and purpose. It should be concise but cover:

### Purpose and Powers

- **Purpose:** To acquire, hold, and manage Carcross Capital LP's membership interest in the acquiring LLC (or C-Corp) that owns AXPONA
- **Powers:** GP has full authority to manage LP affairs, execute documents, make capital contributions to the acquiring LLC, receive and distribute profits, and take all actions necessary to carry out the LP's purpose

### Capital Contributions

- Henry (Carcross)'s initial capital contribution (amount or formula)
- GP authority to make additional capital contributions to the acquiring LLC if needed (e.g., capital calls from the acquiring LLC)
- Henry (Carcross)'s obligation (or right) to make additional contributions as LP

### Distributions

- All distributions received from the acquiring LLC pass through to Henry (Carcross) (sole LP) after payment of LP expenses
- GP (as an entity) typically does not receive a separate economic interest — Henry (Carcross) receives his returns through his LP interest
- Timing: as received from the acquiring LLC

### Tax Matters

- LP files Form 1065 annually (even with one partner, if GP LLC is a separate entity)
- Henry (Carcross) receives K-1 from the LP
- GP LLC designated as partnership representative
- **Opt-out of BBA audit regime** recommended (Section 6221(b)) — eligible with <=100 partners

**Note:** If the GP LLC is disregarded for tax purposes (single-member LLC) and Henry (Carcross) is the sole LP, the IRS may treat the LP as having only one partner. In that case, the LP itself may be treated as a disregarded entity. Consult tax counsel on whether the LP needs to file its own Form 1065 or whether it is simply reported on Henry (Carcross)'s personal return.

### Management and Control

- GP LLC has exclusive authority over LP business
- No LP consent provisions needed (Henry (Carcross) controls both sides)
- GP may delegate authority as needed

### Term and Dissolution

- **Term:** Indefinite, or until the LP's interest in the acquiring LLC is fully liquidated
- **Dissolution triggers:**
  - Henry (Carcross)'s written election to dissolve
  - Sale or liquidation of the LP's interest in the acquiring LLC
  - GP bankruptcy or dissolution (without successor)
  - Judicial decree

### Liability Protection

- Henry (Carcross)'s liability as LP is limited to his capital contribution
- GP LLC's liability is unlimited at the LP level, but Henry (Carcross) is shielded behind the LLC
- Net result: Henry (Carcross) has no personal liability beyond what he invested

---

## 3. Relationship to Acquiring LLC

### Capital Flow

```
Henry (Carcross) → (capital contribution) → Carcross Capital LP → (capital contribution) → Acquiring LLC
                                                                                      ↓
                                                                            Acquires AXPONA assets

AXPONA revenue → Acquiring LLC (retains working capital, pays operating expenses)
  → LLC distributes to all members pro rata
    → Carcross Capital LP receives its member share
      → LP distributes to Henry (Carcross)
```

### Acquiring LLC Operating Agreement (Negotiated with Prim)

Carcross Capital LP will be one member of the acquiring LLC. Key provisions for Henry (Carcross) to negotiate:

- **Management:** Manager-managed structure (TBD who operates day-to-day); Carcross Capital LP is a minority equity member
- **Henry (Carcross)'s operational role:** Board/advisory seat, operational involvement without salary — compensated through equity. Scope of duties, authority, and expense reimbursement should be formalized.
- **Distribution provisions:** Pro rata to members (or per agreed schedule)
- **Information rights:** Carcross Capital LP needs timely financial data and tax info
- **Consent rights:** Protective rights over major decisions (sale of business, additional debt, dilutive capital raises, related-party transactions, change of business purpose)
- **Tag-along / drag-along:** Standard minority investor protections
- **Anti-dilution:** Protection against future issuances at lower valuations
- **Exit provisions:** Right to participate pro rata in any sale; drag-along by majority; tag-along by minority
- **Put/call rights:** Consider whether either party can force a buyout under certain conditions

### Tax Reporting Chain

**If acquiring entity is an LLC (pass-through):**
```
Acquiring LLC (Form 1065) → K-1 to Carcross Capital LP
  Carcross Capital LP (Form 1065) → K-1 to Henry (Carcross)
    Henry (Carcross) → Form 1040
```

**If acquiring entity is a C-Corp:**
```
Acquiring C-Corp (Form 1120) → dividends/1099-DIV to Carcross Capital LP
  Carcross Capital LP (Form 1065) → K-1 to Henry (Carcross) (reporting dividend income)
    Henry (Carcross) → Form 1040
```

---

## 4. Tax Considerations

### Pass-Through Treatment

- Carcross Capital LP is a pass-through entity — no entity-level federal income tax
- All income, deductions, gains, and losses flow through to Henry (Carcross)
- Henry (Carcross) pays tax on his allocated share regardless of whether cash is distributed (if acquiring entity is also pass-through)
- If acquiring entity is C-Corp, Henry (Carcross) only owes tax on dividends actually received

### State Tax

- **Delaware:** No state income tax on LP income for non-residents; $300 annual franchise tax each for LP and GP LLC
- **Illinois:** If acquiring entity is pass-through, Henry (Carcross) owes Illinois income tax on his share of Illinois-sourced income (4.95%)
- **Henry (Carcross)'s home state:** Will tax Henry (Carcross) on his share of LP income (depends on whether Henry (Carcross) is in CA or ID — see jurisdiction check)

### Estate Planning Advantage

The LP structure allows Henry (Carcross) to:
- Gift LP interests to family members with valuation discounts (typically 20-35% discount for lack of marketability + minority interest)
- Retain control through the GP LLC while transferring economic interests
- Reduce estate tax exposure on a growing asset

---

## 5. Jurisdiction Analysis

Four jurisdictions are relevant to Carcross Capital LP: **Delaware** (formation), **Illinois** (where AXPONA operates), **Idaho** and **California** (Henry (Carcross)'s possible domicile).

### Master Comparison Matrix

| Factor | Delaware | Illinois | Idaho | California |
|--------|----------|----------|-------|------------|
| **Role** | LP formation state | AXPONA operations | Henry (Carcross) domicile (option) | Henry (Carcross) domicile (option) |
| **Income tax rate** | None (no ops in DE) | 4.95% on IL-source income | 5.695% flat | Up to 13.3% |
| **Capital gains rate** | N/A | 4.95% | 5.695% | 13.3% (no preference) |
| **Section 199A conformity** | N/A | Yes | Yes | **No** |
| **QSBS (Section 1202) conformity** | N/A | Yes | **Yes** | **No** |
| **LP franchise/entity tax** | $300/yr (flat) | N/A (LP not registered here) | $0 | **$800/yr minimum** |
| **LP registration required?** | Formed here | No (LP is passive holder) | Probably (low burden) | **Yes (FTB aggressive)** |
| **Registration cost** | ~$200 (formation) | N/A | $100 (one-time) | $70 + $800/yr franchise |
| **Annual entity cost** | $300 LP + $300 GP LLC | $0 | ~$0 | **$820+** |
| **Charging order protection** | **Exclusive remedy** (Section 17-703) | N/A | **Exclusive remedy** (Section 30-28-703) | Moderate (foreclosure possible) |
| **Estate tax** | None | None | None | None |
| **Community property** | N/A | N/A | Yes | Yes |
| **Case law depth (LP)** | **Best in nation** | N/A | Limited | Good |
| **Governance flexibility** | **Maximum** (contractual freedom) | N/A | Standard | Standard |

### Tax Impact on Henry (Carcross)'s LP Income

| Annual LP Income | Delaware (entity) | Illinois (source) | Idaho (domicile) | California (domicile) |
|-----------------|-------------------|-------------------|------------------|----------------------|
| $500K | $0 | ~$24,750 | ~$28,500 | ~$53,000 |
| $1M | $0 | ~$49,500 | ~$57,000 | ~$123,000 |

Note: Illinois tax applies as source-state tax on AXPONA income regardless of Henry (Carcross)'s domicile. Henry (Carcross) gets a credit on his home-state return for IL taxes paid.

**Net state tax (after IL credit):**
- Idaho: ~$57,000 - $49,500 IL credit = ~$7,500 additional ID tax (on $1M)
- California: ~$123,000 - $49,500 IL credit = ~$73,500 additional CA tax (on $1M)

### Exit Tax Comparison ($10M Capital Gain)

| Scenario | Federal | Illinois | Idaho | California |
|----------|---------|----------|-------|------------|
| No QSBS | ~$2.38M (23.8%) | ~$495K | ~$569K | ~$1.33M |
| With QSBS (C-Corp, 5+ yr hold) | **$0** | **$0** (conforms) | **$0** (conforms) | **$1.33M** (no conformity) |
| **Total exit tax (QSBS, ID)** | **$0** | **$0** | **$0** | — |
| **Total exit tax (QSBS, CA)** | **$0** | **$0** | — | **$1.33M** |

### 5-Year Cumulative Impact (Illustrative: $1M/yr income + $10M exit)

| | Idaho Domicile | California Domicile | CA Cost Over ID |
|---|---|---|---|
| 5 years income tax (net of IL credit) | ~$37,500 | ~$367,500 | $330,000 |
| Exit tax (QSBS C-Corp) | $0 | $1,330,000 | $1,330,000 |
| LP entity fees (5 years) | ~$0 | ~$4,100 | $4,100 |
| **5-year total** | **~$37,500** | **~$1,701,600** | **~$1,664,100** |

### Why Delaware for Formation

**Delaware remains the correct formation state regardless of Henry (Carcross)'s domicile:**
- Best-developed LP case law; Court of Chancery provides specialized business courts
- Maximum contractual freedom — LP agreements can modify or waive fiduciary duties
- Low franchise tax ($300/year flat for LPs and LLCs)
- No state income tax on entities that don't operate in Delaware
- Exclusive charging order remedy (Section 17-703) — strongest asset protection
- Industry standard for PE/investment vehicles

No compelling reason to form in Illinois, Idaho, California, or any other state.

### Foreign Qualification

Carcross Capital LP is a **passive holding vehicle** — its sole activity is holding a membership interest in the acquiring LLC.

| State | LP Must Register? | Why |
|-------|-------------------|-----|
| Delaware | Formed here | Home state |
| Illinois | **No** | LP has no IL operations; the acquiring LLC (not the LP) operates in IL |
| Idaho | Probably, if Henry (Carcross) is domiciled there | Management decisions from ID; low burden ($100, no annual fee) |
| California | **Yes**, if Henry (Carcross) is domiciled there | FTB aggressive — management from CA = transacting business; $800/yr franchise tax |

The **acquiring LLC** (not Carcross Capital LP) is the entity that must foreign-qualify in Illinois and Connecticut.

---

## Key Filings Checklist

1. Form Carcross Capital GP LLC (Delaware) — ~$90
2. Form Carcross Capital LP (Delaware) — ~$200
3. Registered agent (shared, Delaware) — $50-$300/year
4. Annual franchise tax: $600/year total ($300 LP + $300 GP LLC)
5. Annual Form 1065 filing for Carcross Capital LP (if required — confirm with tax counsel whether LP is disregarded)
6. K-1 to Henry (Carcross)

**Not required (no outside investors):**
- ~~Form D (SEC)~~
- ~~State securities notice filings~~
- ~~ERA/investment adviser registration~~
- ~~AML/KYC procedures~~
- ~~ERISA monitoring~~

---

---

# Scenario B: Carcross Capital LP with Outside Investors (Feeder Fund)

> If Henry (Carcross) later decides to bring outside investors into Carcross Capital LP, the structure becomes a feeder fund. This section covers the additional requirements.

## Entity Diagram (With Investors)

```
Acquiring LLC (buys AXPONA)
  │
  ├── Prim (C-Corp or LLC) — majority partner
  │
  ├── Carcross Capital LP — equity member (% profit + % equity)
  │     ├── GP: Carcross Capital GP LLC (DE LLC, Henry (Carcross), sole member)
  │     ├── LP: Henry (Carcross) — capital commitment
  │     ├── LP: Investor A — capital commitment
  │     ├── LP: Investor B — capital commitment
  │     └── LP: Investor C — capital commitment
  │
  └── Other Members (if any)
```

## What Changes

| Aspect | Scenario A (Henry (Carcross) Only) | Scenario B (With Investors) |
|--------|------------------------|----------------------------|
| Securities law | None | Reg D Rule 506(b) required |
| Form D filing | Not required | Required within 15 days of first sale |
| State notice filings | Not required | Required in each investor's state |
| Accredited investor verification | N/A | Self-certification acceptable (506(b)) |
| Investment Advisers Act | N/A | File as Exempt Reporting Adviser (ERA) |
| AML/KYC | N/A | Best practice (not legally required until 2028) |
| ERISA | N/A | Cap benefit plan investors at <25% or prohibit |
| LP agreement complexity | Simple (formality) | Full PE-style agreement required |
| K-1 reporting | Henry (Carcross) only | Each investor gets K-1 |
| Distribution waterfall | Pass-through to Henry (Carcross) | Multi-tier waterfall (see below) |
| Management fees | None needed | Optional (see below) |
| Tax filing | Form 1065 (may be disregarded) | Form 1065 required |

## Securities Law (Scenario B Only)

### Regulation D — Rule 506(b) (Recommended)

- No general solicitation or advertising
- Unlimited **accredited investors**
- Up to 35 non-accredited sophisticated investors (triggers extra disclosure — avoid if possible)
- Self-certification of accredited status acceptable
- **Federal preemption:** States cannot impose substantive registration, only notice filings

**Accredited Investor Thresholds:**
- Individual income >$200K (or $300K joint) in each of past two years
- Individual net worth >$1M (excluding primary residence)
- Certain professional certifications (Series 7, 65, 82)

### Form D

- File electronically with SEC **within 15 days** of first sale of LP interests
- No filing fee
- Amend annually if offering ongoing
- **State notice filings** required in each state where an investor resides (fees: $0 to $2,000+)

### Investment Advisers Act

- **Private Fund Adviser Exemption (Section 203(m)):** Exempt from SEC registration if solely advising qualifying private funds with <$150M AUM
- **Recommendation:** File as **Exempt Reporting Adviser (ERA)** — short-form ADV, minimal burden

### ERISA

- If **benefit plan investors** (ERISA plans + IRAs) hold **>=25%** of LP interests, LP assets become "plan assets" — triggers fiduciary obligations and prohibited transaction rules
- **Recommendation:** Cap at 24.9% in LP agreement or prohibit ERISA/IRA investments entirely

### AML/KYC

- FinCEN compliance deadline delayed to **January 1, 2028**
- No current federal legal requirement, but best practice: collect ID, verify against OFAC SDN list

## Distribution Waterfall (Scenario B Only)

**Recommended Simple 4-Tier Waterfall:**

| Tier | Description | Allocation |
|------|-------------|------------|
| 1. Return of Capital | LPs receive until 100% of contributed capital returned | 100% to LPs |
| 2. Preferred Return | LPs receive hurdle rate on contributed capital | 8% (industry standard, compounded annually) |
| 3. GP Catch-Up | GP receives until proportionate share of carry achieved | 100% to GP |
| 4. Carried Interest Split | Remaining distributions split | 80% LPs / 20% GP |

Since AXPONA generates recurring annual cash flow, distributions will likely be quarterly or semi-annual.

## Management Fees (Scenario B Only)

- **No traditional PE management fee** is typical for a single-deal co-investment vehicle of this size
- **Optional LP-level fees:**
  - One-time acquisition/placement fee (1-2% of capital committed) for deal sourcing
  - Small ongoing fund administration fee (0.5-1%) to cover LP costs (tax prep, K-1s, reporting)

## Additional LP Agreement Provisions (Scenario B Only)

### Capital Accounts and Allocations

- Capital accounts maintained per Treasury Regulation Section 1.704-1(b)(2)(iv)
- Allocations must satisfy **"substantial economic effect"** test
- Liquidating distributions must follow positive capital account balances

### Limited Partner Rights

**Matters requiring LP consent (supermajority):**
- Amendment of LP agreement (66.7% or 75%)
- Admission of new partners
- Removal of GP (for cause: 50-66.7%; without cause: 75%)
- Dissolution of LP
- Sale of LP's interest in acquiring LLC
- Material transactions outside ordinary course
- Related-party transactions

**Information rights:**
- Annual audited (or reviewed) financial statements
- Annual K-1s by specified deadline
- Quarterly unaudited reports
- Right to inspect books and records (6 Del. C. Section 17-305)

**Transfer restrictions:**
- LP interests non-transferable without GP consent
- Right of first refusal (ROFR) for GP and/or other LPs
- Transfers must comply with securities laws

**Withdrawal:**
- Generally **no right to withdraw** for the term of the LP
- Permitted only in extraordinary circumstances

### GP Removal and Indemnification

- **For cause** (fraud, gross negligence, material breach): 50-66.7% vote
- **Without cause:** 75% vote
- GP indemnified except for gross negligence, willful misconduct, bad faith, fraud
- LP clawback: up to 25% of distributions (2-3 year sunset)

### Partnership Representative (BBA)

- GP LLC designated as partnership representative
- **Opt-out of BBA audit regime** recommended (Section 6221(b))
- If not opted out, push-out election available (Section 6226)

### Key Person Provisions

- Triggered when Henry (Carcross) dies, becomes disabled, or is unable to manage the LP
- LP investors may vote on successor GP, liquidation, or dissolution
- Business operations continue under the acquiring LLC regardless

## Additional Filings (Scenario B Only)

1. Form D (SEC) — within 15 days of first sale, no fee
2. State notice filings — each investor's home state
3. ERA filing (Form ADV) — recommended
4. Form 1065 — required (not disregardable with multiple partners)
5. K-1 to each investor
6. Composite state tax returns or withholding for non-resident partners (if applicable)
