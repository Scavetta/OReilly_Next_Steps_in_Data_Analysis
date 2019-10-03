# Mini-challenges (20 minutes)

# ---- Warning and Error messages ----

# detach the tidyverse package, so we can begin with a clean workspace:
detach("package:tidyverse", unload = TRUE)

# What do the following warning and error messages mean

# 1 
plantgrowth
## Error: object 'plantgrowth' not found

# 2
ggplot2(mtcars, aes(mpg, wt)) +
  geom_point()
## Error in ggplot2(mtcars, aes(mpg, wt)) : 
##   could not find function "ggplot2"

# 3
ggplot(mtcars, aes(mpg, wt)) +
  geom_point()
## Error in ggplot(mtcars, aes(mpg, wt)) : 
##   could not find function "ggplot"

# 4
mtcars(5)
# Error in mtcars(5) : could not find function "mtcars"

# 5
mtcars[5](5)
# Error: attempt to apply non-function

# 6
subset[5]
## Error in subset[5] : object of type 'closure' is not subsettable

# 7
1:30 * 101:104
## Warning message:
##   In 1:30 * 101:104 :
##   longer object length is not a multiple of shorter object length


# ---- Mini-challenge I - Importing difficult data structures ----
# remove the header:


# find the end of the data:


# read only until the end.pos:


# ---- Mini-challenge II: Dealing with type mismatches ----
# What are the current problems with the data?