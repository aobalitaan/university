#AXEL O. BALITAAN
#2022-05153
#CMSC 150 - B2L

#Imports former exercise that extracts from the equations and puts them in a matrix
source("C:/Users/Axel/Desktop/BalitaanEx03_source.R");


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
      
      #If the element is zero, no unique solution exists
      if (mat[pivotRow, i] == 0)
      {
        print("No unique solutions exist.")
        return (0);
      }
      #Performs partial pivoting
      PartialPivoting(mat, pivotRow, i);
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

###################  Equations from the material  #####################
E1 <- function(x1, x2, x3) 0.1 * x1 + 7 * x2 + -0.3 * x3 + 19.3;
E2 <- function(x1, x2, x3) 3 * x1 + -0.1 * x2 + -0.2 * x3 + -7.85;
E3 <- function(x1, x2, x3) 0.3 * x1 + -0.2 * x2 + 10 * x3 + -71.4;

system <- list(E1, E2, E3);
##################################################################


#####################   PROBLEM 1 EQUATIONS   #####################
# E1 <- function (x1, x2, x3, x4, x5, x6, x7) 8000 * x1 + 4500 * x2 + 4000 * x3 + 3000 * x4 + 2000 * x5 + 1000 * x6 + 200 * x7 + -99250000;
# E2 <- function (x1, x2, x3, x4, x5, x6, x7) 7800 * x1 + 6500 * x2 + 5800 * x3 + 0 * x4 + 3100 * x5 + 1600 * x6 + 700 * x7 + -117150000;
# E3 <- function (x1, x2, x3, x4, x5, x6, x7) 10000 * x1 + 0 * x2 + 3100 * x3 + 0 * x4 + 2600 * x5 + 1300 * x6 + 350 * x7 + -78300000;
# E4 <- function (x1, x2, x3, x4, x5, x6, x7) 5200 * x1 + 3700 * x2 + 3100 * x3 + 2700 * x4 + 2400 * x5 + 1800 * x6 + 200 * x7 + -95520000;
# E5 <- function (x1, x2, x3, x4, x5, x6, x7) 7700 * x1 + 7100 * x2 + 0 * x3 + 5700 * x4 + 5100 * x5 + 1300 * x6 + 500 * x7 + -136910000;
# E6 <- function (x1, x2, x3, x4, x5, x6, x7) 9300 * x1 + 8700 * x2 + 6100 * x3 + 5100 * x4 + 4000 * x5 + 1000 * x6 + 100 * x7 + -152170000;
# E7 <- function (x1, x2, x3, x4, x5, x6, x7) 6000 * x1 + 0 * x2 + 5000 * x3 + 4300 * x4 + 3000 * x5 + 1900 * x6 + 300 * x7 + -111450000;
# 
# system <- list(E1, E2, E3, E4, E5, E6, E7);
##################################################################


#####################   PROBLEM 2 EQUATIONS   #####################
# E1 <- function (x1, x2, x3, x4, x5, x6, x7, x8, x9) 4 * x1 + -1 * x2 + -1 * x4 + -80;
# E2 <- function (x1, x2, x3, x4, x5, x6, x7, x8, x9) 4 * x2 + -1 * x1 + -1 * x5 + -1 * x3 + - 30;
# E3 <- function (x1, x2, x3, x4, x5, x6, x7, x8, x9) 4 * x3 + -1 * x2 + -1 * x6 + -80;
# E4 <- function (x1, x2, x3, x4, x5, x6, x7, x8, x9) 4 * x4 + -1 * x1 + -1 * x5 + -1 * x7 + - 50;
# E5 <- function (x1, x2, x3, x4, x5, x6, x7, x8, x9) 4 * x5 + -1 * x2 + -1 * x6 + -1 * x8 + -1 * x4;
# E6 <- function (x1, x2, x3, x4, x5, x6, x7, x8, x9) 4 * x6 + -1 * x3 + -1 * x5 + -1 * x9 + - 50;
# E7 <- function (x1, x2, x3, x4, x5, x6, x7, x8, x9) 4 * x7 + -1 * x4 + -1 * x8 + -120;
# E8 <- function (x1, x2, x3, x4, x5, x6, x7, x8, x9) 4 * x8 + -1 * x5 + -1 * x9 + -1 * x7 + - 70;
# E9 <- function (x1, x2, x3, x4, x5, x6, x7, x8, x9) 4 * x9 + -1 * x6 + -1 * x8 + - 120;
# 
# system <- list(E1, E2, E3, E4, E5, E6, E7, E8, E9);
##################################################################



result1 = AugCoeffMatrix(system);

result2 <- GaussianMethod(result1);
result2;

result3 <- GaussJordanMethod(result1);
result3;
