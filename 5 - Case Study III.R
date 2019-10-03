# Case Study III - Reading in files with a separate legend

# In the data2 folder you'll find the same data as in the data folder, except 
# that the legend contains the values formerly of the Sample column.

# Your job is to read in raw values and the corresponding legend separately 
# and then merge them together. This is a common real world situation.

# These are all the files:
list.files("data2", full.names = T)

# ---- Exercise 1 ----
# Get file names:

# Just get the values, and here just take the first plate:
# Use a pattern in list.files() to specify the pattern to look for:
values <- list.files("data2", ______, full.names = T)[1]
values

# Now find matching legend files:
# Use basename to get the file name only and then just get the prefix before the _
name <- str_extract(______, ".*_")
name

# Use this in the legend name:
legend <- paste0("data2/", name, "legend_plate.txt")
legend

# ---- Exercise 2 ----
# Work with the values, this is as in the previous exercises

# Now read in the values:
qPCR <- read.delim(______, skip = 4, blank.lines.skip = TRUE, na.strings = "Undetermined")
endpos <- grep("Summary", qPCR$Well) - 1
qPCR <- read.delim(______, skip = 4, blank.lines.skip = TRUE, na.strings = "Undetermined", nrows = endpos)
qPCR <- tbl_df(qPCR)

# ---- Exercise 3 ----
# Work on the legend

# Read in the legend:
qPCR_legend <- read_tsv(______)

# Get legend into long format:
# First, use gather() to collect the data to long format, call the key "col" and the value "value"
# Then arrange() to make sure rows appear alphabetically
# Use mutate() to create a variable for Position (i.e. A01, A02, etc), and Well, which is just 1:384
# Remore row and col using select()
qPCR_legend %>%
  gather(______, ______, ______) %>% 
  arrange(______) %>% 
  mutate(Position = ______,
         Well = ______) %>% 
  select(______, ______) -> qPCR_legend

# ---- Exercise 4 ----
# Now mash the values with the legend
# Use left_join() and mutate() to replace the Sample column with the value column from the legend
# Save as qPCR
qPCR %>% 
  left_join(______) %>% 
  mutate(Sample = ______) -> qPCR

# The rest follows as before in section I and II