# Pull Request Checklist

> Take your time to read through these, don't just click through them. Only check the boxes if they apply.

## Admin
<!--- Ensure  -->
- [ ] **Required:** I have read the [contributing guidelines](https://coalfire.atlassian.net/wiki/spaces/CEHOME/pages/2648440862/Pull+Request+Best+Practices) for submitting a PR.

## Types of changes
<!--- What types of changes does your code introduce? -->
- [ ] :bug: Bug fix (non-breaking change which fixes an issue)
- [ ] :sparkle: New feature (non-breaking change which adds functionality)
- [ ] :collision: Breaking change (fix or feature that would cause existing functionality to change)

## Testing

- [ ] **Required:** I have tested the proposed changes to code (i.e. `packer build`, `terraform apply`), and they are working.
- [ ] **Required:** All GitHub Actions ran successfully. If they didn't, I left a note in the description to address this.
- [ ] **Optional:** I have already applied/deployed the changes in my environment.

### Please check where this code has been tested

- [ ] Locally
- [ ] Customer Environment
- [ ] Coalfire Sandbox Environment (AWS GovCloud, Azure Gov, GCP, etc.)

## Documentation

- [ ] **Optional, recommended:** I have updated ***`README.md`***.
- [ ] **Optional, recommended:** I have updated documentation in ***Confluence/Organization's relevant Wiki***.
- [ ] **Optional, recommended:** I left comments ***in-line in the code*** to help others understand the changes.

## Tagging / Assigning

- [ ] **Required:** I have tagged a ***Reviewer(s)***.
- [ ] **Required:** I have tagged an ***Assignee(s)***.
- [ ] **Optional:** I have tagged relevant stakeholders in a ***Comment***.
