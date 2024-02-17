#AXEL O. BALITAAN
#2022-05153
#CMSC 150 - B2L

#Gets the RHS (constant) in each equation
getRHS <- function(plusSplit, variables)
{
  #Default RHS is 0, gets returned if no other was found
  rightHS = 0;
  
  #For every term separated by "+" sign
  for (term in plusSplit)
  {
    #Separates the terms through "*" sign
    multiSplit = unlist(strsplit(term, "\\*"));
   
    if (!(multiSplit[length(multiSplit)] %in% variables))
    {
      #If the last item of vector is not in variables
      #Example : (1, --x4--), (--1--)
  
      if (grepl("^-?\\d*(\\.\\d+)?$", multiSplit[length(multiSplit)]) == TRUE)
      {
        #If that last item is a number
        #changes RHS to the constant (multiplied by -1)
        #Code for grepl derived from:
        #https://stackoverflow.com/questions/15814592/how-do-i-include-negative-decimal-numbers-in-this-regular-expression
        rightHS = (-1*as.numeric(multiSplit[1]));
      }
     
      else
      {
        #If the last item is a variable but not in the vector of declared variable
        #Example: function(x1, x2) 1*x1 + 1*x2 + --1*x3--
        #returns NA, indicating that there must be some inconsistencies
        return (NA);
      }
    }
  }
  
  #Returns RHS value
  return (rightHS);
}

#Gets the coefficient of a specific variable through each equation
getVarCoeff <- function(refVar, plusSplit)
{
  #For every term separated by "+" sign
  for (term in plusSplit)
  {
    #Separates the terms through "*" sign
    multiSplit = unlist(strsplit(term, "\\*"));
    
    #If the separated term is only one and only a variable (e.g just x1, x2, or x3)
    if ((length(multiSplit) == 1) && (multiSplit[1] == refVar))
    {
      #returns 1 as the coefficient
      return (1);
    }

    #If the separated term is with a constant + a variable that is same with the reference
    if ((length(multiSplit) == 2) && (multiSplit[2] == refVar))
    {
      #returns the constant
      return (as.numeric(multiSplit[1]));
    }
  }
  
  #If the variable not found in the equation (but declared), returns 0 as coefficient (same with 0 * x1)
  return (0);
}

#Gets the coefficients and RHS of equations
getCoeff <- function(system, variables)
{
  #Initializes empty coefficient vector
  coefficients = c();
  
  #Iterates through each equation
  for (equation in system)
  {
    #Remove spaces in the equation
    spaceRemoved = gsub(" ", "", deparse(equation)[2]);
    #Splits the terms through "+" symbol
    plusSplit = unlist(strsplit(spaceRemoved, "\\+"));
    
    #loops through each variable in the variable vector
    for (refVar in variables)
    {
      #Gets coefficient of each variable
      coefficients = c(coefficients, getVarCoeff(refVar, plusSplit));
    }
    #Gets RHS of each equation
    coefficients = c(coefficients, getRHS(plusSplit, variables));
  }
  
  #Returns the coefficient vector
  return (coefficients);
}

#Compares variables vector to a reference vector (similar functionality to setequal())
varCompare <- function(refVarVector, varsExtracted)
{
  #If variables are not of same amount, already returns FALSE
  if (length(refVarVector) != length(varsExtracted))
  {
    return (FALSE);
  }
  
  #Checks if each variable is in the reference vector
  for (var in varsExtracted)
  {
    #If not in the ref vector, returns False
    if (!(var %in% refVarVector))
    {
      return (FALSE);
    }
  }
  
  #If same length and all was in the ref vector, return TRUE 
  return (TRUE);
}

#Gets the variables of the equations
getVars <- function(system)
{
  #Initializes empty vector for reference
  refVarVector = c();
  
  #iterates through each equation
  for (equation in system)
  {
    #Remove spaces of deparsed[1], the function(x1, x2, x3...) part
    spaceRemoved = gsub(" ", "", deparse(equation)[1]);
    #Remove the string "function" and the characters "()" from the spaceRemoved
    funcRemoved = substring(spaceRemoved, 10, nchar(spaceRemoved) - 1);
    #Extracts the variables using comma
    varsExtracted = unlist(strsplit(funcRemoved, ","));
    
    #If it was the first equation, stores it as a reference and loops immediately
    if (length(refVarVector) == 0)
    {
      refVarVector = varsExtracted;
      next;
    }
    
    #Checks if the extracted variables are same with the reference, if not returns NA
    if (!varCompare(refVarVector, varsExtracted))
    {
      return (NA);
    }
  }
  
  #If all are same, returns the reference variables
  return (refVarVector);
}

#Gets the Augmented Coefficient Matrix of equations
AugCoeffMatrix <- function(system)
{
  #Gets the variables of the equations
  variables = getVars(system);
  
  #If the variables did not match early returns
  if (anyNA(variables))
  {
    print ("Variables did not match.")
    return (NA);
  }
  
  #If matched, gets the coefficients
  coeff = getCoeff(system, variables);
  
  #If any of the coefficient results to NA
  if (anyNA(coeff))
  {
    #prompts user taht there are some inconsistencies
    print ("Encountered variable(s) used but not declared in the function.")
    return (NA);
  }
  
  #Initializes rows and column names
  rownames = (1:length(system));
  colnames = c(variables, "RHS");
  
  #Initializes the matrix
  augcoeffmatrix <- matrix(
    coeff, 
    nrow = length(rownames), 
    ncol = length(colnames), 
    byrow = TRUE,
    dimname = list(rownames, colnames));
  
  #returns the list with variables and the matrix
  return (list(variables=variables, augcoeffmatrix=augcoeffmatrix));
  
}

#Function Equations
E1 <- function (x1,x2,x3) 0.3 * x1 + -0.2 * x2 + 10 * x3 + -71.4;
E2 <- function (x1,x2,x3) 3 * x1 + -0.2 * x3 + -0.1 * x2 + -7.85;
E3 <- function (x1,x2,x3) 0.1 * x1 + 7 * x2 + -0.3 * x3 + 19.3;

system <- list(E1, E2, E3);

result1 = AugCoeffMatrix(system);
result1;