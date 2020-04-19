# Install from CRAN
install.packages('data.table')
# install.packages('curl')

#Intialize library
library(data.table)

setwd("~/R/data.table_v3")

#why use data.table?
# speed of execution on larger data.


# Create a large .csv file
set.seed(100)
m <- data.frame(matrix(runif(10000000), nrow=1000000))
write.csv(m, 'm2.csv', row.names = F)

# Time taken by read.csv to import
system.time({m_df <- read.csv('m2.csv')})

#The fread(), short for fast read is data.tables version of read.csv().

# Time taken by fread to import
system.time({m_dt <- fread('m2.csv')})


flights <- fread("https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv")

#fread accepts http and https URLs directly as well as operating system commands such as sed and awk output. See ?fread for examples.

colnames(flights)

head(flights)

class(flights)

#Convert data.table to dataframe
flights <- as.data.frame(flights)

#Convert dataframe to data.table
flights <- as.data.table(flights)





DT[i, j, by]

##   R:   i          j          by
## SQL:  where |  select |   group by


# Subset rows in i

#df way
ans <- flights[flights$origin == "JFK" & flights$month == 6]
head(ans)

#dt way
ans <- flights[origin == "JFK" & month == 6]
head(ans)

#Subset first 2 rows
ans <- flights[1:2]
ans

# Select column(s) in j

ans <- flights[, arr_delay]
head(ans)
class(ans)

#Select arr_delay column, but returns it as a vector.


ans <- flights[, list(arr_delay)]
head(ans)
class(ans)

ans <- flights[, .(arr_delay, dep_delay)]
head(ans)


ans <- flights[, .(delay_arr = arr_delay, delay_dep = dep_delay)]
head(ans)

# Compute or do in j

# How many trips have had total delay < 0

ans <- flights[, sum((arr_delay + dep_delay) < 0 )]
ans

head(flights)

# Subset in i and do in j

ans <- flights[origin == "JFK" & month == 6,
               .(m_arr = mean(arr_delay), m_dep = mean(dep_delay))]
ans

# How many trips have been made in 2014 from "JFK" airport in the month of June?

ans <- flights[origin == "JFK" & month == 6, length(dest)]
ans

# Special symbol .N:
# 
# .N is a special built-in variable that holds the number of observations in the current group. It is particularly useful when combined with by as we'll see in the next section. In the absence of group by operations, it simply returns the number of rows in the subset.


ans <- flights[origin == "JFK" & month == 6, .N]
ans

#Aggregations

#Grouping using by

ans <- flights[, .N, by = .(origin)]
ans


# How can we calculate the number of trips for each origin airport for carrier code "AA"?
ans <- flights[carrier == 'AA', .N, by = .(origin)]
ans

# How can we get the total number of trips for each origin, dest pair for carrier code "AA"?

ans <- flights[carrier == 'AA', .N, by = .(origin,dest)]
ans

#using order by
ans <- flights[carrier == "AA", .N, by = .(origin, dest)][order(origin, -dest)]
head(ans, 10)
ans

#Boolean group by
ans <- flights[, .N, .(dep_delay>0, arr_delay>0)]
ans


ans <- flights[carrier == "AA",
               .(mean(arr_delay), mean(dep_delay)),
               by = .(origin, dest, month)]
head(ans,12)
ans

#using keyby
ans <- flights[carrier == "AA",
               .(mean(arr_delay), mean(dep_delay)),
               keyby = .(origin, dest, month)]
head(ans,12)
ans

#All we did was to change by to keyby. This automatically orders the result by the grouping variables in increasing order. In fact, due to the internal implementation of by first requiring a sort before recovering the original table's order, keyby is typically faster than by because it doesn't require this second step.

flights[carrier == "AA",                       
        lapply(.SD, mean),                    
        by = .(origin, dest),           
        .SDcols = c("arr_delay", "dep_delay")]  

# How can we return the first two rows for each month?
ans <- flights[, head(.SD, 2), by = month]
head(ans)
# 
# Summary
# The general form of data.table syntax is:
#   
#   DT[i, j, by]
#
# 


# Using i:
#   We can subset rows similar to a data.frame- except you don't have to use DT$ repetitively since columns within the frame of a data.table are seen as if they are variables.
# 



# Using j:
#   Select columns the data.table way: DT[, .(colA, colB)].
# 
# Select columns the data.frame way: DT[, c("colA", "colB")].
# 
# Compute on columns: DT[, .(sum(colA), mean(colB))].
# 
# Provide names if necessary: DT[, .(sA =sum(colA), mB = mean(colB))].
# 
# Combine with i: DT[colA > value, sum(colB)].
# 



# Using by:
#   Using by, we can group by columns by specifying a list of columns or a character vector of column names or even expressions. The flexibility of j, combined with by and i makes for a very powerful syntax.
# 
# by can handle multiple columns.
# 
# We can keyby grouping columns to automatically sort the grouped result.
# 
# We can use .SD and .SDcols in j to operate on multiple columns using already familiar base functions.



































