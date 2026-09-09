# EU Merger Review and State Ownership: Methodological Pilot

## Why I built this

I built this small pilot while reading through the proposed PhD project on competition law enforcement in mixed markets.

I wanted to understand how the data side of the project could work in practice and, at the same time, improve my R skills.

The idea was to see how information from EU merger decisions could be linked with ownership information about the companies involved, and then used to look at outcomes such as Phase II review, remedies or review duration.

## Data and workflow

I put together a small set of 27 EUMR merger cases for the pilot and organised the information into three tables:

- merger decisions;
- the companies involved in each merger; and
- ownership information for those companies.

In R, I linked the three tables, matched ownership information to the relevant year, created different measures of State ownership and State control, and then combined the information so that each merger appeared once in the final dataset.

### Pilot data summary

| Pilot sample | Number of cases |
|---|---:|
| Total merger cases | 27 |
| Phase I decisions | 20 |
| Phase II decisions | 7 |
| Cases with remedies | 5 |
| Confirmed cases involving State ownership | 5 |
| Confirmed private cases | 0 |
| Ownership classification unresolved / incomplete | 22 |

The last two rows became an important part of the exercise. If ownership information was missing, I did not want to assume that the company was privately owned. I therefore kept those cases as unknown instead of creating a private group that I could not justify.

For the same reason, I kept State ownership and State control as separate variables. A State can own shares in a company without necessarily controlling it, so I did not want to treat the two as the same thing.

## Regression demonstration

The real pilot is too small and has too much missing ownership information to draw reliable conclusions about whether State-owned companies are treated differently in merger review.

Instead of forcing the real data into a regression, I created a separate synthetic dataset of 200 hypothetical merger cases and used it only to practise the regression workflow in R.

I first ran a simple logistic regression looking at the relationship between State ownership and Phase II review. I then added transaction size and sector to see how the result changed when other factors were taken into account.

The results from the synthetic dataset are not findings about European Commission enforcement. This part of the pilot was only meant to help me understand how the proposed analysis could be implemented in practice.

## What I learned

The most useful part of the pilot was not the regression itself.

It was seeing how much depends on the work done before the model is even run: identifying the right company, matching ownership information to the right year, deciding what counts as State ownership, keeping ownership and control separate, and dealing properly with missing information.

## Files

`01_import_clean.R` – imports and cleans the data

`02_match_construct.R` – links the datasets and creates the case-level variables

`03_demo_regression.R` – demonstrates the regression workflow using synthetic data
