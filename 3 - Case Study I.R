# Case study: Part 1 (60 minutes)

# Lecture: Introduction of new data set
# Exploratory Data Analysis (EDA)
# Developing a strategy: 
#   From scratch to a reportable solution; 
#   Descriptive & inferential statistics, 
#   plotting; 
#   Transforming variables, 
#   Extracting p-values

# ---- PART 0: Import the data ----
# We did this in the previous script "2 - Mini-challenges.R"
# you can copy your final command here:





# ---- PART 1: Clean up the data ----

# ---- Exercise 1 ----
# Take only samples which begin with c or d.

# ---- Exercise 2 ----
# Select only the variables of interest: Well, Sample, Detector, Ct

# ---- Exercise 3 ----
# ---- The sample variable actually contains three variables. Split it up into three columns, called:
# Treatment, Genotype, Sample

# ---- Exercise 4 ----
# Group the data according to Well, Treatment, Genotype, Sample
# We group according to Well since each well contains two probes, the endogenous control and the experimental target.
# This will allows us to select value pairs that we know belong together. That’s very important!
  
# ---- Exercise 5 ----
# Since we're going to perform transformation functions between the EC and the Ct, 
# we’re going to separate the data in a way that allows this to be easy for us.
# For each of the groups defined above, calculate the following variables.
# - EC: The Ct of the Endogenous Control, i.e. the value of the Ct variable where the Detector equals "18S rRNA".
# - Ct: The Ct of the Experimental probe, i.e. the value of the Ct variable where the Detector DOES NOT equal "18S rRNA".
# - DeltaCt: Ct - EC
# - Detector: The name of the detector in the Detector variable that DOES NOT equal 18S rRNA.

# ---- Exercise 6 ----
# Finally, update the object qPCR with this new version. Use glimpse() to view it.

# Enter the solutions to Exercises 1-6 here:



# ---- PART 1B: Extra plotting challenges ----
# plot the delta Ct values as per the presentation
# I'll show you how to adjust the position using this command:
pos.jd = position_jitterdodge(dodge.width = 0.1, jitter.width = 0.1)



# ---- PART 2A: Calculate summary statistics ----
# ---- Exercise 7 ----
# Cluster the data into groups according to Treatment, Genotype, Detector

# ---- Exercise 8 ----
# Calculate the average (avg) and the SEM (SEM) of each technical triplicate for both the Ct and EC variables.

# ---- Exercise 9 ----
# Apply a transformation function to calculate DeltaCt, which ic Ct_avg - EC_avg

# ---- Exercise 10 ----
# Ungroup the data frame and regroup according to Detector.

# ---- Exercise 11 ----
# Apply a transformation function to calculate:
  
# - DeltaDeltaCt DeltaCt - DeltaCt[Genotype == "-/-" \& Treatment == "c"]
# - FC 2^-(DeltaDeltaCt)
# - MaxFoldChange 2^-(DeltaDeltaCt - Ct_SEM)
# - MinFoldChange 2^-(DeltaDeltaCt + Ct_SEM))
# Save the output as qPCR_summary


# Enter your solutions for exercises 7 - 11 here



# ---- PART 2B: Extra plotting challenges ----
# Plot the fold change with a pointrange geom as in the presentation
# We'll use this position change here:
pos.d = position_dodge(width = 0.1)




# ---- PART 3: Inferential statistics: two-way ANOVA ----
# ---- Exercise 12 ----
# begin with qPCR and build a complete dplyr command with the \%>\% operator.
# The first five commands (group_by(), summarise_at(), mutate(), ungroup(), and group_by()) are as per the above section, 
# with the exception that here, we’ll group according to four variables: Detector, Treatment, Genotype, Sample

# ---- Exercise 13 ----
# Calculate a linear model for each detector according to the formula 
# DeltaCt ~ (Treatment + Genotype)^2.
# Don’t forget to specify the data argument in lm(), since this is not a dplyr function and it is 
# not the first argument – use the . notation for this. Progress to calculate an ANOVA table from the 
# linear models and reiterate this over all the groups.

# ---- Exercise 14 ----
# Extract only the following columns of interest:
# Detector, term, p.value
# Save the output as qPCR_results

# Enter your solutions to exercises 12 - 14 here:
# We'll use this package to get a nice format for our stats functions
library(broom)
