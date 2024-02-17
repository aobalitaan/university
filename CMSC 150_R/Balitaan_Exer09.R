# AXEL O. BALITAAN
# CMSC 150 - B2L
# Muller Method


MullerMethod <- function (f, x0, x1, x2, macheps, max = 1000, verbose = TRUE)
{
  # Stores given initial approximates
  Given_x0 = x0;  
  Given_x1 = x1;
  Given_x2 = x2;
  
  # Initializes iterations
  iterations = 0;
  ea = 100;
  
  mat_val = c();  # Stores values for matrix 
  
  # Main Loop
  while (ea >= macheps && iterations != max)
  {
    # Solves for values of f given the approximates
    y0 = f(x0);
    y1 = f(x1);
    y2 = f(x2);
    
    # 
    h0 = x1 - x0;
    h1 = x2 - x1;
    
    d0 = (y1 - y0) / h0;
    d1 = (y2 - y1) / h1;
    
    A = (d1 - d0) / (h1 + h0);
    B = A * h1 + d1;
    C = f(x2);
    
    # Evaluates which sign is needed for x3
    sign = abs(B - sqrt(B^2 - 4 * A * C)) < abs(B + sqrt(B^2 - 4 * A * C))
    
    # x3 positive and negative versions
    x3_pos = x2 - (2 * C) / (B + sqrt(B^2 - 4 * A * C));
    x3_neg = x2 - (2 * C) / (B - sqrt(B^2 - 4 * A * C));
    
    x3 = ifelse(sign, x3_pos, x3_neg);  # Assigns value to x3 depending on sign
    
    ea = abs((x3 - x2) / x3) * 100; # Computes error
    
    # Stores value to matrix
    row_val = list(x0, x1, x2, y0, y1, y2, A, B, C, x3, f(x3), ea);
    mat_val = c(mat_val, row_val);
    
    # Updates iteration count
    iterations = iterations + 1;
    
    # Terminates if root was found
    if (f(x3) == 0)
    {
      break;
    }
    
    # Updates approximates
    x0 = x1;
    x1 = x2
    x2 = x3;
  }
  
  # If verbose == TRUE prints the matrix containing each iteration
  if (verbose == TRUE)
  {
    mat_ans = matrix(mat_val, nrow = iterations, ncol = length(row_val), byrow = TRUE, dimnames = list(c(1:iterations), c("x0", "x1", "x2", "f(x0)", "f(x1)", "f(x2)", "A", "B", "C", "x3", "f(x3)", "Error")));
    print(mat_ans);
    writeLines("");
  }
  
  # Returns required values
  return (list(f = f, Given_x0 = Given_x0, Given_x1 = Given_x1, Given_x2 = Given_x2, x3 = x3, iterations = iterations, ea = ea))
}


# Significant digits
options(digits = 4);

####################### HANDOUT ##############################
# f <- function (x) cos(x);
# 
# # Initial guess approximates
# x0 = 0;
# x1 = 2;
# x2 = 4;
# macheps = 1 * (10 ^ -5);
# max = 1000;
# verbose = TRUE;
# #############################################################


################ WORD PROBLEM ##############################
f <- function (x) (x ^ 3) + (3.5 * (x ^ 2)) - 40;
# Graphs the function
curve(f, from = -3, to = 3, xlab = "x", ylab = "y");

# Initial guess approximates
x0 = -3;
x1 = 0;
x2 = 3;
macheps = 1 * (10 ^ -9);
max = 100000;
verbose = TRUE;
#############################################################

MullerMethod (f, x0, x1, x2, macheps, max, verbose);
