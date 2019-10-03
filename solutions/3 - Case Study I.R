# Case study: Part 1 (60 minutes)

# Lecture: Introduction of new data set
# Exploratory Data Analysis (EDA)
# Developing a strategy: 
#   From scratch to a reportable solution; 
#   Descriptive & inferential statistics, 
#   plotting; 
#   Transforming variables, 
#   extracting

# ---- Import the data ----
# We did this in the previous script "2 - Mini-challenges.R"
# you can copy zour final command here:
qPCR <- read.delim("data/Atrogin1.txt", skip = 4, blank.lines.skip = TRUE, na.strings = "Undetermined")
endpos <- grep("Summary", qPCR$Well) - 1
qPCR <- read.delim("data/Atrogin1.txt", skip = 4, blank.lines.skip = TRUE, na.strings = "Undetermined", nrows = endpos)
qPCR <- tbl_df(qPCR)


# ---- Clean up the data ----

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

qPCR %>%
  filter(grepl("^[c|d] ", Sample)) %>%                                      # Exercise 1
  select(Well, Sample, Detector, Ct) %>%                                    # Exercise 2
  separate(Sample, c("Treatment", "Genotype", "Sample"), " ") %>%           # Exercise 3
  group_by(Well, Treatment, Genotype, Sample) %>%                           # Exercise 4
  summarise(EC = Ct[Detector == "18S rRNA"],                                # Exercise 5
                   Ct = Ct[Detector != "18S rRNA"],
                   DeltaCt = Ct - EC,
                   Detector = Detector[Detector != "18S rRNA"]) -> qPCR

# ---- Extra plotting challenges ----
pos.d = position_dodge(width = 0.1)
pos.jd = position_jitterdodge(dodge.width = 0.1, jitter.width = 0.1)

ggplot(qPCR, aes(x = Treatment, y = DeltaCt, colour = Sample)) +
  geom_point(shape = 16, position = pos.jd, alpha = 0.75) +
  scale_y_continuous("Delta Ct") +
  facet_grid(Genotype ~ Detector) +
  theme_classic()
# ggsave("qPCR_raw_1_myo.png", height = 6, width = 6, units = "in")

ggplot(qPCR, aes(x = Treatment, y = DeltaCt, colour = Genotype)) +
  geom_point(shape = 16, position = pos.jd, alpha = 0.75) +
  scale_y_continuous("Delta Ct") +
  scale_colour_discrete("Genotype") +
  facet_grid(. ~ Detector) +
  theme_classic()
# ggsave("qPCR_raw_2_myo.png", height = 6, width = 6, units = "in")


# ---- Calculate summary statistics ----
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

qPCR %>%
  group_by(Treatment, Genotype, Detector) %>%                                          # Exercise 7
  summarise_at(vars(EC, Ct), funs(avg = mean(.),
                                  SEM = sd(.)/sqrt(length(.)) )) %>%                   # Exercise 8
  mutate(DeltaCt = Ct_avg - EC_avg) %>%                                                # Exercise 9
  ungroup() %>%                                                                        # Exercise 10
  group_by(Detector) %>%
  mutate(DeltaDeltaCt = DeltaCt - DeltaCt[Genotype == "-/-" & Treatment == "c"],       # Exercise 11
         FC = 2^-(DeltaDeltaCt),
         MaxFoldChange = 2^-(DeltaDeltaCt - Ct_SEM),
         MinFoldChange = 2^-(DeltaDeltaCt + Ct_SEM)) -> qPCR_summary


ggplot(qPCR_summary, aes(x = Treatment, y = FC, colour = Genotype)) +
  geom_pointrange(aes(ymin = MinFoldChange, ymax = MaxFoldChange), position = pos.d) +
  scale_y_continuous("Delta Ct") +
  scale_colour_discrete("Genotype") +
  facet_grid(. ~ Detector) +
  theme_classic()
ggsave("qPCR_FC_myo.png", height = 6, width = 6, units = "in")


# ---- Inferential statistics: two-way ANOVA ----
# Exercise 12
# begin with qPCR and build a complete dplyr command with the \%>\% operator.
# The first five commands (group_by(), summarise_at(), mutate(), ungroup(), and group_by()) are as per the above section, 
# with the exception that here, we’ll 
# Group according to four variables: Detector, Treatment, Genotype, Sample

# Exercise 13 
# Calculate a linear model for each detector according to the formula 
# DeltaCt ~ (Treatment + Genotype)^2.
# Don’t forget to specify the data argument in lm(), since this is not a dplyr function and it is 
# not the first argument – use the . notation for this. Progress to calculate an ANOVA table from the 
# linear models and reiterate this over all the groups.

# Exercise 14 Extract only the following columns of interest:
# Detector, term, p.value

library(broom)
qPCR %>%
  group_by(Detector, Treatment, Genotype, Sample) %>%                      # Exercise 12
  summarise_at(vars(EC, Ct), funs(avg = mean(.),
                                  SEM = sd(.)/sqrt(length(.)) )) %>%
  mutate(DeltaCt = Ct_avg - EC_avg) %>%
  ungroup() %>%
  group_by(Detector) %>%                                                    # As per above
  do(tidy(anova(lm(DeltaCt ~ (Treatment + Genotype)^2, data=.)))) %>%              # Exercise 13
  select(Detector, term, p.value) -> qPCR_results                                           # Exercise 14

# print to screen
qPCR_results

# ---- Iterate your Script ----
# Exercise 15 
# Take the cumulative dplyr commands you’ve written to calculate the fold-change, 
# including importing in the file, and generalise it to use the MyoD1.txt file.

