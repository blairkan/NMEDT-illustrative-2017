# NMEDT-illustrative-2017

Illustrative analyses for the Naturalistic Music EEG Dataset - Tempo (NMED-T). 

## Overview
These scripts reproduce the figures in the following paper: 

Steven Losorelli, Duc T. Nguyen, Jacek P. Dmochowski, and Blair Kaneshiro (2017). [NMED-T: A Tempo-Focused Dataset of Cortical and Behavioral Responses to Naturalistic Music](https://ccrma.stanford.edu/groups/meri/assets/pdf/losorelli2017ISMIR.pdf). In *Proceedings of the 18th International Society for Music Information Retrieval Conference*, Suzhou, China.

The dataset is available for download here:

Steven Losorelli, Duc T. Nguyen, Jacek P. Dmochowski, and Blair Kaneshiro (2017). Naturalistic Music EEG Dataset - Tempo (NMED-T). Stanford Digital Repository. Available from: [https://purl.stanford.edu/jn859kj8079](https://purl.stanford.edu/jn859kj8079).

If you use or adapt this code, we ask that you cite the above paper. If utilizing the data, please cite the dataset as well.

## License
This toolbox is licensed under a [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/) license. See [LICENSE.md](LICENSE.md) for more information.

## Getting started
In order to run these analyses, the user should download the EEG dataset from the [Stanford Digital Repository](https://purl.stanford.edu/jn859kj8079). All contents of this repository should be downloaded and their directory structure retained.

## Main scripts

### NMEDT\_SDR\_1\_EEG.m
This script reproduces the EEG analyses and recreates the contents of Figure 2 of the paper. Note that the user must have EEGLAB installed in order to render the topoplot. 

### NMEDT\_SDR\_2\_ratings.m
This script loads the behavioral responses and recreates the contents of Figure 3 of the paper. 

### NMEDT\_SDR\_3\_tapping.m
This script reproduces the analyses on the tapping responses and recreates the contents of Figure 4 of the paper. 

## Contact
Contact blairbo@ccrma.stanford.edu with any questions.