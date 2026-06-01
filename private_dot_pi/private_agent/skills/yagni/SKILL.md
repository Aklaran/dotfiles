---
name: yagni
description: Use when asked to review a product spec, PRD, build plan, architecture plan, implementation plan, or MVP roadmap — to simplify it, identify what can be deferred, tighten MVP scope, flag feature creep or premature abstraction, avoid agent-added product debt, challenge "helpful" extras, or prepare concise feedback for another agent, PM, or engineer.
---

# YAGNI Review

Review the plan as a pragmatic MVP editor. Preserve the user's strategic intent, but reduce unnecessary implementation surface.

## Core Stance

Prevent product slop: features that work, but are not useful, not coherent with the product, or not justified by current user needs.

Optimize for the smallest useful system that proves the product shape.

Prefer:
- Clear source of truth
- Deterministic core logic
- Thin interfaces
- Explicit deferrals
- Future seams that do not require building the future system now
- Human review where product judgment is still needed

Avoid:
- Features added because they are easy for agents to build
- UI surface before the data model works
- Workflow gates before the workflow is validated
- Generic frameworks before repeated use
- Parser-heavy imports before canonical structured input exists
- Full auth, roles, permissions, or audit systems before real users require them
- Agent-specific abstractions before agents are actually writing to the system

## Review Questions

For each feature, ask:

1. Current need
   - Is this required for the MVP's primary workflow?
   - Who uses it in the first version?

2. Coherence
   - Does this fit the product's main job?
   - Would it make the product easier to understand, or just more impressive?

3. Cost of now
   - What useful work is delayed if this is built now?
   - Will this add maintenance, UI, documentation, or testing surface?

4. Cost of later
   - Is this hard to add later?
   - If it is cheap to add later, defer it.

5. Future seam
   - Can a schema, API, or documentation seam preserve optionality without implementing the future system?
   - Prefer the seam over the system.

6. Risk protection
   - Does this prevent data loss, silent mutation, duplicate money/time records, security exposure, or compliance risk?
   - Keep small safeguards that protect the core record.

## Common YAGNI Smells

Flag these unless there is a specific current reason:

- `--dry-run` modes for low-risk helper scripts
- Batching before there is real volume
- Pagination before result sets are large
- Plugin/provider architectures before there are two real providers
- Arbitrary Markdown/prose import before canonical JSON or typed input exists
- Rich admin panels before operators exist
- Full RBAC before there are real roles
- Audit-log systems before the audit questions are known
- Dashboards and analytics before usage data matters
- Saved views, filters, sorting, and bulk actions before users ask
- Background jobs, queues, retries, and schedulers before synchronous work fails
- Notifications before there is a real interrupt-worthy event
- Approval workflows before the approval policy is validated
- Multi-tenant, white-label, i18n, theming, or branding systems for an internal MVP
- "AI assistant" features that do not improve the core workflow
- MCP/plugin integrations when a clean API seam is enough for now
- Complex diff/preview systems when version history or discardable drafts are sufficient
- Spreadsheet-grade editing when users only need preview and small edits
- High-precision requirements without evidence for the precision
- Configurable settings with no named user or decision that needs them

## Valid Exceptions

Do not over-apply YAGNI. Keep a feature if it is needed to:

- Prevent destructive or irreversible changes
- Avoid duplicate financial/time records
- Preserve a contractual or approved baseline
- Protect sensitive data
- Make the core system easy to change later
- Support a confirmed near-term integration
- Match actual expected data volume
- Keep tests fast and reliable
- Preserve one clear home for business logic

YAGNI means simple and correct, not sloppy.

## Output Format

Return:

1. Verdict
   - Approve, revise, or reject the plan direction in one short paragraph.

2. Keep
   - What is core to V1.

3. Defer
   - Useful later, not needed now.

4. Simplify
   - Keep the intent, reduce the implementation.

5. Clarify
   - Ambiguities likely to cause rework.

6. Revised Build Order
   - Short sequence focused on proving the core artifact.

7. Message Back
   - Concise feedback the user can send to the plan author.

## Grounding Notes

YAGNI argues against adding future-facing complexity before it is needed. It does not mean cutting quality, tests, or malleability. Product slop is the product-management analog: polished features or specs that appear complete but lack enough context, usefulness, or coherence to move the product forward.
