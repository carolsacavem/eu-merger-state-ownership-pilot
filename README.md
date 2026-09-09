# Mixed Markets Pilot: EU Merger Review and State Ownership

## Purpose

This is a small methodological pilot inspired by the proposed PhD project on competition law enforcement in mixed markets.

The aim was to understand, in practice, how the proposed merger-control analysis could be structured in R. The PhD proposal envisages linking a decisions panel with undertaking-level ownership data and examining whether merger review differs when one of the parties is State-owned. The relevant outcomes may include Phase II investigation, remedies and review duration.

## What I did

I built a small dataset of 27 EU merger cases and separated the information into:

- merger decisions;
- parties to each transaction; and
- undertaking-level ownership information.

In R, I:

- imported and cleaned the three datasets;
- linked merger parties to ownership observations;
- created alternative indicators for State ownership and State control;
- aggregated the data to one observation per merger;
- coded Phase II investigation and remedies as binary outcomes.

The exercise highlighted the importance of keeping State shareholding and State control separate, and of preserving missing ownership information rather than automatically treating an undertaking as privately owned.

## Why I did not regress the real sample

The 27 cases were selected for methodological testing rather than through a representative sampling strategy.

Ownership information was also incomplete for several observations. The real pilot therefore cannot support substantive statistical inference about whether State-owned undertakings receive different treatment.

Rather than recoding missing observations as private or interpreting results from a biased sample, I used the real data only to demonstrate dataset construction and coding.

## Simulated regression

I then created a separate synthetic dataset of 200 hypothetical merger cases to practise the regression workflow.

I estimated two illustrative logistic regression models:

1. Phase II investigation predicted by State ownership.
2. Phase II investigation predicted by State ownership while also accounting for transaction size and sector.

The simulated coefficients and p-values are not empirical findings. The simulation is included solely to demonstrate how the proposed analytical approach could be implemented in R.

## Main methodological lessons

The pilot showed that:

- company and case identifiers need to be matched carefully;
- ownership must be linked to the relevant point in time;
- missing ownership information is not equivalent to private ownership;
- State shareholding and legal control may produce different classifications;
- the definition of a State-owned undertaking can therefore affect the empirical analysis;
- sector and other transaction characteristics may need to be considered when analysing differences in merger scrutiny.

## Files

- `01_import_clean.R` – imports and cleans the data
- `02_match_construct.R` – links the datasets and constructs the merger-level variables
- `03_demo_regression.R` – demonstrates the regression workflow using simulated data

## Limitation

This project is a methodological exercise, not an empirical study of European Commission enforcement practice.