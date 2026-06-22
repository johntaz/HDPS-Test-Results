# Incorporating laboratory test information in high-dimensional propensity score analyses

This repository contains data management and analysis scripts for incorporating laboratory test information in high-dimensional propensity score analyses, as described in:

> Tazare J, Brown JP, Morales DR, Smeeth L, Evans SJW, Douglas, IJ, Williamson EJ. Methods for incorporating test result information within the high-dimensional propensity score framework: application in UK electronic health record data. **BMC Methods**. 2026. doi: 10.1186/s12874-026-02926-w.

## Repository Structure

The following scripts assume construction of a sudy cohort study with binary treatment group, baseline covariates and binary outcome.  

### Data management

Scripts starting 'dm_*' implement data cleaning rules for laboratory test values, including the generation of cut-off variables.

### Analysis

Scripts starting 'an_*' incorporate the generated variables in the HDPS procedure. 






