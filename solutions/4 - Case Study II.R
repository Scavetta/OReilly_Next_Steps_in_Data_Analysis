# Case study: Part 2 (60 minutes)

# Steps in completing our solution
#  Merging data frames
#  Working with lists and results of statistics
#  Reiteration

# ---- Exercise 1 ----
# Create a function that will calculate the ANOVA for all the genes in a file,
# Which is where we ended the last script. 
# Call it process_qPCR()

# Use this generic form for your function
myFun <- function(x) {
  y <- x*100
  return(y)
}

myFun(4)

process_qPCR <- function(x) {
  qPCR <- read.delim(x, skip = 4, blank.lines.skip = TRUE, na.strings = "Undetermined")
  endpos <- grep("Summary", qPCR$Well) - 1
  qPCR <- read.delim(x, skip = 4, blank.lines.skip = TRUE, na.strings = "Undetermined", nrows = endpos)
  qPCR <- tbl_df(qPCR)
  
  qPCR %>%
    filter(grepl("^[c|d] ", Sample)) %>%                                      # Exercise 1
    select(Well, Sample, Detector, Ct) %>%                                    # Exercise 2
    separate(Sample, c("Treatment", "Genotype", "Sample"), " ") %>%           # Exercise 3
    group_by(Well, Treatment, Genotype, Sample) %>%                           # Exercise 4
    summarise(EC = Ct[Detector == "18S rRNA"],                                # Exercise 5
              Ct = Ct[Detector != "18S rRNA"],
              DeltaCt = Ct - EC,
              Detector = Detector[Detector != "18S rRNA"]) -> qPCR
  qPCR %>%
    group_by(Detector, Treatment, Genotype, Sample) %>%                      # Exercise 12
    summarise_at(vars(EC, Ct), funs(avg = mean(.),
                                    SEM = sd(.)/sqrt(length(.)) )) %>%
    mutate(DeltaCt = Ct_avg - EC_avg) %>%
    ungroup() %>%
    group_by(Detector) %>%                                                    # As per above
    do(tidy(anova(lm(DeltaCt ~ (Treatment + Genotype)^2, data=.)))) %>%       # Exercise 13
    select(Detector, term, p.value) -> qPCR_results                           # Exercise 14
  return(qPCR_results)
}

# ---- Exercise 2 ----
# Check to see that your function works:
process_qPCR("data/Atrogin1.txt")

# ---- Exercise 3 ----
# Get list of all files in the "data/" directory, including their full names
# Assign this to the object myFiles
myFiles <- list.files("data/", full.names = T)

# ---- Exercise 4 ----
# "map" each element myFiules onto the process_qPCR function you calculated above.
myFiles %>% 
  map_df(~ process_qPCR(.))