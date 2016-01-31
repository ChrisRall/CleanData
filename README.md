IMPORTANT: Be sure to set your current working directory to the directory where the Samsung data and subfolders are located.

to execute the run_analysis.R file, download the run_analysis.R file into your working directory and type:
source("run_analysis.R")

at the prompt.

The script will then:
1. read in all relevant TXT files
2. combine data sets into one data frame.
3. subset out only the mean and std columns
4. clean up and rename all data variables and column names to make them human-readable
5. save this cleaned data in a variable called "data"
6. summarize the cleaned data by subject and activity, and calculate the mean for each variable measured.
7. save this summarized data into a separate data frame called "data_averages"
8. write this data frame to a TXT file in your working directory called "data_averages.txt"

Code book for variable names:

subject = the unique ID for the person being measured.
activity = the description of the activity being measured.  i.e. Walking.

