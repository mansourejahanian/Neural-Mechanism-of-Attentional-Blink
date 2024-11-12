# Neural-Mechanism-of-Attentional-Blink

## Abstract

The human brain has inherent limitations in consciously processing visual information. When individuals monitor a rapid sequence of images for detecting two targets, they often miss the second target (T2) if it appears within a short time frame of 200-500ms after the first target (T1), a phenomenon known as the attentional blink (AB). The neural mechanism behind the attentional blink (AB) remains unclear, largely due to the use of simplistic visual items such as letters and digits in conventional AB experiments, which differ significantly from naturalistic vision. This study employs advanced multivariate pattern analysis (MVPA) of human EEG data (including 17 females and 18 males) to explore the neural representations associated with target processing within a naturalistic paradigm under conditions where AB does or does not occur. Our MVPA analysis successfully decoded the identity of target images from EEG data. Moreover, in the AB condition, characterized by a limited time between targets, T1 processing coincided with T2 processing, resulting in the suppression of late representational markers of both T1 and T2. Conversely, in the condition with longer inter-target interval, neural representations endured for a longer duration. These findings suggest that the attentional blink can be attributed to the suppression of neural representations in the later stages of target processing.

## Study Title

Multivariate Pattern Analysis of EEG Reveals Neural Mechanism of Naturalistic Target Processing in Attentional Blink.

## Description

This folder contains all codes required for data analysis and plotting figures

Experiment_design/Main.m:
This script is the design of the main experiment containing all the blocks.

Experiment_design/Practice.m:
This script is one practice block for familiarization.

Experiment_design/stimuli/:
This folder contains all the preprocessed stimuli that were used in the experiment.

Experiment_design/records/:
This folder can be used to store behavioral data.

Experiment_design/functions/:
This folder contains the required functions for the design of the experiment.

Behvaior/calculating_accuracy.m:
This script calculates the behavior performance of all participants,
and plot the average reporting accuracy per target per lag condition across all participants.

Behavior/functions/:
This folder contains the required functions for calculating reporting accuracy for each lag condition
and for each target image.

Stat_visual/:
This folder contains all statistic functions required and color.m script for visualization.

Decoding/average_decoding.m:
This script calculates the average decoding accuracy time series across all participants and plots the results per lag condition per target.

Decoding/calculate_decoding_score.m:
This script calculates the average decoding score within 200 ms time windows and plots the results per lag condition per target.

Decoding/functions/:
This folder contains the required functions for decoding analysis.

Temporalgen/average_temporalgen.m:
This script calculates the average temporal generalization maps across all participants and plots the results per lag condition per target.

Temporalgen/calculate_tg_score.m:
This script calculates the average temporal generalization score within 200*200 ms^2 time windows and plots the results per lag condition per target.

Correct_vs_incorrect/correct_incorrect_decoding.m:
This script calculates average decoding accuracy time series or temporal generalization maps across all participants 
for correct versus incorrect T2 responses in the lag 3 condition, and plot the results.

Correct_vs_incorrect/functions/:
This folder contains the required functions for decoding analysis for correct versus incorrect responses.

## Data
Data and stimuli can be found at https://osf.io/9syzf/

## Authors

Data collection conducted by Mansoure Jahanian \
Western Institute for Neuroscience, Western University, London, Canada \
email: mjahani@uwo.ca

The Principal Investigator of the study is Dr. Yalda Mohsenzadeh \
Western Institute for Neuroscience, Western University, London, Canada \
email: ymohsenz@uwo.ca

The co-investigator of the study is Dr. Marc Joanisse \
Western Institute for Neuroscience, Western University, London, Canada \
email: marcj@uwo.ca

## Citation

