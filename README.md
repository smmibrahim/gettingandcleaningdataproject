The HCRActivityWithSmartphone file contains tidy data representing the average values for several observations made on 30 individuals when they performed six activities - Walking, Walking Upstairs, Walking Downstairs, Sitting, Standing and Laying as part of the Human Activity Recognition experiments conducted by:

==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Universit? degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws

For description of the varibles look into the CodeBook.md file.
To obtain the tidy data from the initial raw data obtained by the above investigators, we used a set of R commands. This set of commands is detailed in the run_analysis.R file. The commands will work if the raw data is downloaded into a sub-directory of the working directory called UCI HAR Dataset with further two folders called train and test, which contain the raw data.