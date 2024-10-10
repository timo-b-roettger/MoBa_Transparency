# MoBa Transparency Project
The associated repository for the MoBa Transparency project

## parseHTML-MoBaPublicaitons
Contains script and data for scraping the Moba Publication list.

## analysis
### data
- `pilot_data.csv`: contains the data for pilot assessment (n=60)
- `test_data.csv`: contains the data for pilot assessment (n=945)
- `test_coding_assignment.csv`: contains the data including coder assignments
- `gsheet_rawdata.csv`: contains the downloaded google sheet data containing the first round of coding of the test data.
- `OA_assessment.csv`: contains the assessment of open access (OA) by a separate coder.
- `duplicates.csv`: contains duplicates in the data and was send to coders to manually correct.
- `duplicates_checked.csv`: corrected duplicate list to remerge with the data.
- `data_consensus.csv`: table that contained entries where coder 1 and 2 mismatched; exported for consensus coding.
- `derived_data_table.csv`: final data table after correction of duplicates and after consensus coding; input to `02_descriptive_stats.Rmd`

### scripts
- `pilot_data_draw.R`: reads `prasedHTML_MoBaPublications.csv`, removes duplicates from list and draws a random sample of 60 articles for a pilot coding; stores pilot sample into `pilot_data.csv`; stores rest in `test_data.csv`.
- `test_data_draw.R` assigns `test_data.csv` to 6 different coders; randomly samples 20% of articles for each coder and assigns it to a second coder for cross-validation; stores information in `test_coding_assignment.csv`.
- `01_wrangle_gsheet.Rmd`: Shapes data; resolves inconsistent coding; bins categories; identified duplicates;
- `02_descriptive_stats.Rmd`: Summarises data and creates figure.


