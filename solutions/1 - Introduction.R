# Review of core concepts of “Data Analysis”

# Here I'll review some concepts and functions we used in my "First Steps in Data Analysis with R" class.
# All of this should be familiar to you, if it's not, consider taking that class.

# We used a built-in data sets that I preped in the set up file, so run this:
source("0 - Set-up.R")

# And we used functions in the tidyverse suite of packages:
library(tidyverse)

# ---- Descriptive statistics ---- 
mean(PlantGrowth$weight)

# ---- Applying transformation and aggregation functions ----
PlantGrowth %>% 
  group_by(group) %>% 
  summarise(average = mean(weight),
            stdev = sd(weight),
            n = n())

PlantGrowth %>% 
  group_by(group) %>% 
  mutate(z_1 = (weight - mean(weight))/sd(weight),
         z_2 = scale(weight))

# ---- Inferential statistics ---- 
plant_lm <- lm(weight ~ group, data = PlantGrowth)
anova(plant_lm)

# ---- Plotting ---- 
ggplot(PlantGrowth, aes(x = group, y = weight)) +
  geom_jitter(width = 0.2, alpha = 0.65)

# ---- Query data according to specific criteria
# In the First Steps in Data Analysis class we used a different data set for this example:
barley <- lattice::barley

# The highest yield variety at Waseca in 1932
# Using filter, select, arrange:
barley %>% 
  filter(site == "Waseca" & year == "1932") %>% 
  select(yield, variety) %>% 
  arrange(desc(yield)) %>% 
  slice(1)

# More succintly:
# arrange and immediatly take top 1 row
barley %>% 
  filter(site == "Waseca" & year == "1932") %>% 
  select(yield, variety) %>% 
  top_n(1, yield)