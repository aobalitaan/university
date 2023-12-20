############### REGRESSION LOGIC ###############



# AXEL O. BALITAAN
# 2022 - 05153
# Regression program that gets regression coefficients, equation (string), equation (parsed), added a function for graphing


source("Logic/gaussMethods.R")

# Gets the RHS values for the augcoeffmatrix
getRHS <- function(xVal, yVal, j)
{
  return (sum((xVal ^ (j-1)) * yVal)); # returns RHS value
}

# Gets the augcoeffmatrix
getMatrix <- function(deg, xVal, yVal)
{
  augcoeffmatrix = matrix(c(0), nrow = deg + 1, ncol = deg + 2); # Creates an empty matrix of the corresponding size
  
  tempRowValues = c(); # Starts with an empty vector
  
  for (i in 1:(2 * deg + 1)) # Fills the vector with all the values that will be needed
  {
    val = sum(xVal ^ (i-1))
    tempRowValues = c(tempRowValues, val)
  }
  
  for (j in 1 : (deg + 1)) # Fills the rows of the matrix (splice/iterates starting and ending index of values in the temporary Row vector)
  {
    augcoeffmatrix[j,] = c(tempRowValues[j : (j + deg)], getRHS(xVal, yVal, j)); # Gets the RHS
  }
  
  return (augcoeffmatrix); # Returns the filled augcoeffmatrix
}

# Creates string function
makeString <- function(coefficients) 
{
  polynomial_string = "function(x) "; # Starts the string
  
  for (i in (0 : (length(coefficients) - 1))) # for every coefficient (starts at 0 for x^0)
  {
    var = paste (" * x ^", toString(i)); # Initially sets variable to x ^ i
    plus = " + "; # By default, has a plus sign
    
    if (i == 0) # If x ^ 0, doesn't need to write it
    {
      var = "";
    }
    
    if (i == (length(coefficients) - 1)) # If last term, doesn't need a plus
    {
      plus = "";
    }
    
    term = paste(toString(coefficients[i+1]), var, plus, sep = "", collapse = NULL); # combines the term ( "c * x ^ i + " )
    
    polynomial_string = paste(polynomial_string, term, sep = "", collapse = NULL); # appends the term to the string
  }
  
  return (polynomial_string); # return final string
}

PolynomialRegression <- function(deg, val, estimate)
{
  xVal = val[,1]; # Gets the x values vector from the list
  yVal = val[,2]; # Gets the y values vector from the list
  
  n = length(xVal); # Sets number of terms as the number of x values
 
  if (length(xVal) != length(yVal)) # If the number of x values and y values not equal, doesn't proceed
  {
    print("Number of x and y value not equal.");
    return (NULL);
  }
  
  if ((deg < 0) || (deg >= n)) # If degree, greater than or equal to number of terms, doesn't proceed
  {
    print("Invalid degree.");
    return (NULL);
  }
  
 
  
  augcoeffmatrix = getMatrix(deg, xVal, yVal); # Creates the augcoeffmatrix
 
  
  holderVars = c(1:(deg + 1)); # ***** Holder variables just for the code from previous exercise to work *****
  
  result1 = list(augcoeffmatrix = augcoeffmatrix, variables = holderVars);
  
  coefficients = GaussJordanMethod(result1) $solution; # Gets the solution vector using the GaussianMethod of previous exercise
 
  if (is.null(coefficients))
  {
    return (list(y_estimate = "ERROR", polynomial_string = "ERROR", polynomial_function = "ERROR", xVal = xVal, yVal = yVal))
  }
  
  polynomial_string = makeString(coefficients); # Creates the string function polynomial
  polynomial_function = eval(parse(text = polynomial_string)); # Creates the parsed function
  
  y_estimate = polynomial_function(estimate)
  
  return (list(y_estimate = y_estimate, polynomial_string = polynomial_string, polynomial_function = polynomial_function, xVal = xVal, yVal = yVal))
}

# Graphs the function (plots and use the equation for the line)
graph <- function(given, answers)
{
  par(mar = c(6,8,6,6));
  plot(given[[1]], given[[2]], pch = 20, col = "red", main = "Amount Paid vs. ROI", xlab = "Amount Paid\n(in thousand)", ylab = "ROI\n(in ten thousand)") # Plots the values

  
  colors = c("blue", "red", "green", "orange", "purple")

  for (i in 1:length(answers)) # Adds the lines of each equation(function solution)
  {
    currFunction = answers[[i]]$polynomial_function;

    lines(given[[1]], currFunction(given[[1]]), col = colors[i], lwd = 1);
  }
}
#=================================================

# a <- c(20,20,25,27,30,30,33,35,35,40);
# b <- c(8.75,9.43,12.87,14.24,16.89,18.94,25.48,30.11,36.07,51.27);
# 
# given = data.frame(a, b);
# 
# linearModel = lm(b ~ a, data = given);
# print(linearModel)
# 
# quadraticModel = lm(b ~ poly(a, 5, raw=TRUE), data = given);
# print(quadraticModel)
# 
# 
# deg1 = PolynomialRegression(1, list(a,b));
# deg2 = PolynomialRegression(2, list(a,b));
# deg3 = PolynomialRegression(3, list(a,b));
# deg4 = PolynomialRegression(4, list(a,b));
# deg5 = PolynomialRegression(5, list(a,b));
# 
# answers = list(deg1, deg2, deg3, deg4, deg5);
#graph(list(a,b), answers);

#================================================
# a <- c(1, 3, 6, 7)
# b <- c(10, 20, 19, 33);
# 
# PolynomialRegression(3, list(a,b))

