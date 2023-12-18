source("Logic/gaussMethods.R")

quadraticSpline <- function(data, xEval)
{
  rData = nrow(data)
  cData = ncol(data)
  
  eqtns = createEquation(data, rData - 1)
  eqtns = eqtns[-1,-1]
  
  sol = GaussJordanMethod(list(augcoeffmatrix = eqtns, variables = ncol(eqtns[,-ncol(eqtns)]))) $ solution
  sol = matrix(sol, nrow = 1)
  
  sol = cbind(0, sol)
  
  colnames(sol) = c("A1", colnames(eqtns[,-ncol(eqtns)]))
  
  fx = createFunctions(sol)
  
  if ((xEval > data[rData, 1]) || (xEval < data[1, 1]))
  {
    return (list(fx = fx$fxString, yEval = NULL, y_fx = NULL))
  }
  
  result = evaluateX(data, fx$fx, xEval)
  
  return (list(fx = fx$fxString, yEval = result$yEval, y_fx = result$y_fx))
}

createEquation <- function(data, n)
{
  eqtns = matrix(0, nrow = (3 * n), ncol = (3 * n) + 1)

  var <- paste0(rep(c("A", "B", "C"), n), rep(1:n, each = 3))
  colnames(eqtns) <- c(var, "RHS")
  
  mat_ptr = 2
  col_ptr = 1
  
  for (i in 2:n)
  {
    b = data[i,1]
    a = b ^ 2
    y = data[i,2]
    
    eqtns[mat_ptr, col_ptr:(col_ptr + 2)] = c(a, b, 1)
    eqtns[mat_ptr, (3 * n) + 1] = y
    
    col_ptr = col_ptr + 3
    
    eqtns[mat_ptr + 1, col_ptr:(col_ptr + 2)] = c(a, b, 1)
    eqtns[mat_ptr + 1, (3 * n) + 1] = y
    
    mat_ptr = mat_ptr + 2
  }
  
  b = data[c(1, n + 1), 1]
  y = y = data[c(1, n + 1), 2]
  a = b ^ 2
  
  eqtns[mat_ptr, 1:3] = c(a[1], b[1], 1)
  eqtns[mat_ptr, (3 * n) + 1] = y[1]
  
  eqtns[mat_ptr + 1, (3 * n - 2):(3 * n)] = c(a[2], b[2], 1)
  eqtns[mat_ptr + 1, (3 * n) + 1] = y[2]
  
  mat_ptr = mat_ptr + 2
  
  col_ptr = 1
  for (i in 2:n)
  {
    a = 2 * data[i,1]
    
    eqtns[mat_ptr, col_ptr:(col_ptr + 4)] = c(a, 1, 0, -a, -1)
    col_ptr = col_ptr + 3
    mat_ptr = mat_ptr + 1
  }
  
  return (eqtns)
}

createFunctions <- function(sol) {
  fx = c()
  fxString = c()
  
  for (i in seq(from = 1, to = ncol(sol), by = 3))
  {
    subSol = sol[1,i:(i+2)]
    
    intervFxString = paste("function (x) ", paste0("( ", subSol, " * (x ^ ", 2:0, ") )", collapse = " + "))
    intervFx = eval(parse(text = intervFxString))
    
    
    fx = c(fx, intervFx)
    fxString = c(fxString, intervFxString)
  }
  
  return(list(fx = fx, fxString = fxString))
}

evaluateX <- function(data, fx, xEval)
{
  for (i in 2:nrow(data))
  {
    if (xEval <= data[i,1])
    {
      y_fx = i-1;
      yEval = fx[[i - 1]](xEval);
      
      return(list(y_fx = y_fx, yEval = yEval))
    }
  }
}

splineProcess <- function(data, xEval)
{
  sorted_mat <- as.matrix(data[order(data[, 1]), ])
  quadraticSpline(sorted_mat, xEval)
}