# AXEL O. BALITAAN
# 2022 - 05153
# CMSC 150 - B2L


# Function for False Position method
FalsePositionMethod <- function (f, a, b, macheps, max, verbose)
{
  # Stores initial a and b values for return 
  given_a = a;
  given_b = b;
  
  if (f(a) * f(b) >= 0)
  {
    print("The upper and lower limit doesn't bracket a root.")
    return (NA);
  }
  
  ea = 100; # Initializes ea for the loop to start
  iterations = 0; # Initializes number of iterations to zero
  
  mat_val = c();  # Empty vector for values for the matrix
  
  while ((ea >= macheps) && (iterations != max)) # Loops until reached desired error or iterations is max
  {
    c = (b * f(a) - a * f(b)) / (f(a) - f(b));  # Computes c value
    
    if (f(c) == 0)  # If f(c) == 0, root is found
    {
      break;
    }
    
    row_val = c(list(a, b, f(a), f(b)));  # Creates row values, with a, b, f(a), f(b)
    
    if (f(c) * f(a) < 0)  # Updates interval
    {
      b = c;
      update = "b = c";
    }
    else
    {
      a = c;
      update = "a = c";
    }
    
    if (iterations != 0)  # From 2nd to nth iteration
    {
      ea = abs((c - c_old) / c) * 100;  # Computes error
    }
    
    # Appends other values needed in the matrix
    row_val = c(row_val, list(c, f(c), update, ifelse(iterations != 0, ea, NA)))
    
    iterations = iterations + 1;  # Iterate counter
    mat_val = c(mat_val, row_val);  # Adds current row values to the compilation of mat values
    
    c_old = c;  # Stores current c (previous c of next iteration)
  }
  
  # Initializes matrix
  mat_ans = matrix(mat_val, nrow = iterations, ncol = length(row_val), byrow = TRUE,
                       dimnames = list(c(1:iterations), c("a", "b", "f(a)", "f(b)", "c", "f(c)", "Update", "Error(%)")))
  
  # Prints matrix if needed
  if (verbose == TRUE)
  {
    print(mat_ans);
    writeLines("");
  }
  
  # Returns needed values
  return (list(f = f, given_a = given_a, given_b = given_b, c = c, iterations = iterations, ea = ea));
}

# Function for Secant Method
SecantMethod <- function (f, x0, x1, macheps, max, verbose)
{
  # Stores initial approximates (x0 and x1) values for return 
  given_x0 = x0;
  given_x1 = x1;
  
  # Gets y0 and y1 value (initial function evals)
  y0 = f (x0);
  y1 = f (x1);
  
  # Initializes error and number of iterations
  ea = 100;
  iterations = 0;
  
  mat_val = c(); # Empty vector for matrix values 
  
  while ((ea >= macheps) && (iterations != max))  # Loops until reached desired error or iterations is max
  {
    x = x1 - ((x1 - x0) * y1) / (y1 - y0); # Solves for x
    y = f(x); # Computes function value of x
    
    if (f(x) == 0)  # Checks if x is the root
    {
      break;
    }
    
    # Computes error of 2nd iteration to n
    if (iterations != 0)
    {
      ea = abs((x - x_old) / x) * 100;
    }
    
    # Gets and appends necessary matrix values
    row_val = c(list(x0, x1, f(x0), f(x1), x, f(x), ifelse(iterations != 0, ea, NA)));
    mat_val = c(mat_val, row_val)
    
    x0 = x1;  # First approx = Second Approx
    y0 = y1;
    x1 = x;   # Second approx = Computed Approx
    y1 = y;
    iterations = iterations + 1;  # Iterates counter
    
    x_old = x;  # Stores current x (prev x for next iteration)
  }
  
  # Initializes matrix
  mat_ans = matrix(mat_val, nrow = iterations, ncol = length(row_val), byrow = TRUE,
                   dimnames = list(c(1:iterations), c("x0", "x1", "f(x0)", "f(x1)", "x", "f(x)", "Error(%)")))
  
  # Prints matrix if needed
  if (verbose == TRUE)
  {
    print(mat_ans);
    writeLines("");
  }
  
  # Returns needed values
  return (list (f = f, given_x0 = given_x0, given_x1 = given_x1, x = x, iterations = iterations, ea = ea));
}


#######################################################

options(digits = 4);

f <- function(x) -26 + 85 * x - 91 * x ^ 2 - 44 * x ^ 3 - 8 * x ^ 4 + x ^ 5;
a = 14
b = 12
macheps = 1 * (10 ^ (-9));
max = 100000;
verbose = TRUE;

FalsePositionMethod (f, a, b, macheps, max, verbose);

#######################################################


f <- function(x) sin(x) + cos (1 + x ^ 2) - 1;
x0 = 1.0;
x1 = 3.0;
max = 100000;
verbose = TRUE;

SecantMethod (f, x0, x1, macheps, max, verbose);

#######################################################