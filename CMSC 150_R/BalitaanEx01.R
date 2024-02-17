#AXEL O. BALITAAN
#CMSC 150 - B2L
#2022-05153
#R script for counting frequency of integers 

#Input vector of numbers
vec_input <- c(1,9,7,6,1,2,9,7,3)

#Frequency counter function
freq <- function(data)
{
  #Case for no data
  if (length(data) == 0)
  {
    return("Data Vector Empty")
  }
  
  #Obtains the levels of the input
  factor_data <- factor(data)
  levels_data <- as.integer(levels(factor_data))
  
  #Initializes a vector of how many frequency variables to obtain using the number of levels
  frequency_data <- c(length(levels_data))
  
  #Will be used for indexing the frequency vector
  level_index = 1
  
  #Loops the levels vector
  for (level in levels_data)
  {
    #Initializes how many times the level appears
    frequency_counter = 0
    #Loops the input vector
    for (value in data)
    {
      #If the value is same with the current level
      if (value == level)
      {
        #Adds to the frequency
        frequency_counter = frequency_counter + 1
      }
    }
    #Appends the frequency to the frequency vector of the current index
    frequency_data[level_index] = frequency_counter
    #Iterates to the next element/index in the frequency vector
    level_index = level_index + 1
  }
  
  #Creates the frequency Matrix
  frequency_matrix <- matrix(
    c(levels_data, frequency_data),
    nrow = length(levels_data),
    ncol = 2,
    byrow = FALSE,
    dimname = list(c(1:length(levels_data)), c("Unique Value", "Frequency"))
  )
  
  #Prints the current matrix
  print(frequency_matrix)
}

#Pass the input vector to the function
freq(vec_input)