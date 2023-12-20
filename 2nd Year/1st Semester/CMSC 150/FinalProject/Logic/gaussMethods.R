############### GAUSS JORDAN LOGIC ###############


#AXEL O. BALITAAN
#2022-05153
#CMSC 150 - B2L

#Imports former exercise that extracts from the equations and puts them in a matrix
#source("C:/Users/Axel/Desktop/BalitaanEx03_source.R");


#Swap function for partial pivoting
PartialPivoting <- function(mat, pivotRow, i)
{
  #Stores original mat row in temp
  temp = mat[i,];
  #Changes the mat row with pivotRow
  mat[i,] = mat[pivotRow,];
  #Changes the pivotRow with the orig mat row
  mat[pivotRow,] = temp;
  
  #Returns the final mat
  return (mat);
}

#Function for Gaussian Method
GaussianMethod <- function(result1)
{
  #Extracts the contents of the results from former exercise
  mat = result1 $augcoeffmatrix;
  variables = result1 $variables;
  
  #Gets how many rows in the matrix
  n = nrow(mat);
  
  #
  for (i in 1:(n-1))
  {
    
    #Gets the index of row with maximum var value
    #which.max accepts the rows except the ones that was already iterated through
    #Has +(i-1) to compensate to compensate for this (align with the indexing of the main matrix)
    pivotRow = which.max(abs(mat[i:n,i])) + (i-1);
    
    #If the value is 0 just returns NA
    if (mat[pivotRow, i] == 0)
    {
      return (NA);
    }
    
    #pivots the row and puts it in the current iteration index (Swap)
    mat = PartialPivoting(mat, pivotRow, i);
    
    #F
    for (j in (i+1):n)
    {
      #Gets pivot element
      pivotElement = mat[i,i];
      #Calculates multiplier
      multiplier = mat[j,i]/pivotElement;
      #Computes the normalized row
      normalizedRow = multiplier * mat[i,];
      #Subtraction/Elimination and updates the matrix
      mat[j,] = mat[j,] - normalizedRow;
    }
  }
  
  #Initialized an empty vector for the solutions (answers)
  sol = c(numeric(length(variables)));
  
  #Backward substitution
  for (i in n:1)
  {
    #Obtains the values of each element
    sol[i] = (mat[i,n+1] - sum(mat[i, i:n] * sol[i:n])) / mat[i,i];
  }
  
  #Returns list of answers  
  return (list(variables = variables, augcoeffMatrix = mat, solution = sol));
}

#Function for Gauss Jordan Method
GaussJordanMethod <- function(result1)
{
  #Extracts the content of the results from former exercise
  mat = result1 $augcoeffmatrix;
  variables = result1 $variables;
  
  #Gets how many rows in matrix
  n = nrow(mat);
  
  #Iterates through each row
  for (i in 1:n)
  {
    if (i != n)
    {
      #Gets the index of row with maximum var value
      #which.max accepts the rows except the ones that was already iterated through
      #Has +(i-1) to compensate to compensate for this (align with the indexing of the main matrix)
      pivotRow = which.max(abs(mat[i:n,i])) + (i-1);
      
      if (length(mat[pivotRow, i]) == 0)
      {
        return (NULL)
      }
      
      
      #If the element is zero, no unique solution exists
      if (mat[pivotRow, i] == 0)
      {
        print("No unique solutions exist.")
        return (0);
      }
      #Performs partial pivoting
      mat = PartialPivoting(mat, pivotRow, i);
    }
    
    #Divides row i by its pivot element  
    mat[i,] = mat[i,] / mat[i,i];
    
    for (j in 1:n)
    {
      #Skips row i
      if (i==j)
      {
        next;
      }
      #Multiplies row i by the element in row j and column i
      normalizedRow = mat[j,i] * mat[i,]
      #Subtracts the normalized row to the row (eliminates other elements except the 1 in diagonal)
      mat[j,] = mat[j,] - normalizedRow;
    }
  }
  
  #Returns a list of the answers
  return (list(variables = variables, augcoeffMatrix = mat, solution = as.vector(mat[,ncol(mat)])));
}