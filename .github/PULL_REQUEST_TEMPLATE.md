# Pull Request Checklist

> Please take a moment to review this checklist carefully — only check items that genuinely apply. This helps maintain code quality, traceability, and review integrity.

---

## Admin
- [ ] **Required:** I have read the [contributing guidelines](https://coalfire.atlassian.net/wiki/spaces/CEHOME/pages/2648440862/Pull+Request+Best+Practices) for submitting a PR.

---

## Types of Changes (Required Conventional Commits)
> We follow **Conventional Commits** to keep history readable and automate changelogs/releases.  
> Use `!` after the type (e.g., `feat!:` or `fix!:`) to indicate a **breaking change**.

- [ ] **feat:** Introduces a new feature or capability for users.
- [ ] **fix:** Resolves a bug or unintended behavior.
- [ ] **chore:** Maintenance or tooling changes that don’t affect runtime behavior.
- [ ] **docs:** Documentation-only changes (README, comments, wiki, etc.).
- [ ] **refactor:** Code restructuring that doesn’t change functionality.
- [ ] **test:** Adds or updates tests without changing production code.
- [ ] **ci:** Updates to CI/CD pipelines or automation workflows.

---

## AI Assistance Disclosure (Required)
> We encourage responsible AI usage. Disclosure helps reviewers apply extra scrutiny to prevent hallucinations, logic errors, or insecure patterns.

- [ ] **I used AI assistance while creating this PR**
- [ ] **I did NOT use AI assistance for this PR**

If AI was used, briefly describe:
- What tools were used (e.g., ChatGPT, Copilot, Claude)
- What it helped with (e.g., refactoring, test generation, docs)
- Any areas that may require extra review

<!-- Example: “Used ChatGPT to refactor Terraform locals — manually validated logic and security.” -->

---

## Testing

- [ ] **Required:** I tested the proposed changes (e.g., `terraform apply`, `packer build`, app runtime tests).
- [ ] **Required:** All GitHub Actions checks passed, or failures are documented in the PR description.
- [ ] **Optional:** I have already deployed or validated this change in a real environment.

### Tested In:
- [ ] Local development environment
- [ ] Customer environment
- [ ] Coalfire Sandbox (AWS GovCloud, Azure Gov, GCP, etc.)

---

## Documentation

- [ ] **Recommended:** Updated ***README.md*** where applicable
- [ ] **Recommended:** Updated relevant ***Confluence / Wiki*** documentation
- [ ] **Recommended:** Added inline comments or context for complex logic

---

## Tagging / Ownership

- [ ] **Required:** Reviewer(s) assigned
- [ ] **Required:** Assignee(s) assigned
- [ ] **Optional:** Relevant stakeholders notified via comment

---

## Optional: Reviewer Guidance
> Call out risky areas, architectural decisions, or areas needing deeper review.

<!-- Example: “Please focus review on auth middleware changes and IAM policy updates.” -->
