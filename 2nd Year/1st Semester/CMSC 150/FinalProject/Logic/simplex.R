############### SIMPLEX LOGIC ###############




simplexMinimize <- function(dataInput, minimum, maximum, maxserve)
{
  augcoeffmat = getAugCoeff(dataInput, minimum, maximum, maxserve) # Sets up the augcoeffmat
  dualTableu = setUpTableu(augcoeffmat) # Makes the dual (tranposed) tableu
  simplexResult = simplexMaximize(dualTableu) # Perform simplex maximization the dual tableu

  
  costCol = which(dataInput$Foods %in% colnames(simplexResult$final$basicSol))# find index of colnames(simplexResult$final$basicSol) in datadataInput$Foods
  
  priceVec = as.numeric(gsub("\\$", "", dataInput[,2][costCol]))
  
  foodCost = simplexResult$final$basicSol * c(priceVec, 1)
  
  simplexResult$final$basicSol = rbind(simplexResult$final$basicSol, foodCost)
  rownames(simplexResult$final$basicSol) = c("SERVING", "PRICE")
  simplexResult$final$basicSol[1, ncol(simplexResult$final$basicSol)] = ""
  
  print(simplexResult$final$basicSol)
  
  
  return (simplexResult)
}

getBasicSol <- function(tableau, isFinal)
{
  # Function for getting the basic solution
  
  lastRow = nrow(tableau)
  lastCol = ncol(tableau)
  
  basicSol = matrix(NA, nrow = 1, ncol = ncol(tableau) - 1)
  foodNames = rownames(tableau)[-nrow(tableau)]
  sCount = lastCol - 2 - length(foodNames)  
  colnames(basicSol) = c(paste0("S", 1:sCount), foodNames, "TOTAL COST")
  rownames(basicSol) = "SOLUTION"
  
  
  # If already final iteration
  if (isFinal == TRUE)
  {
   # Gets the last row
    
    basicSol[1,] = tableau[lastRow,-(lastCol-1)]

    basicSol = basicSol[, !grepl("^S\\d+$", colnames(basicSol))]
    
    # Removes variable solutions with result of 0
    basicSol = as.matrix(basicSol[-which(basicSol == 0)])
    colnames(basicSol) = "SERVING"
    basicSol = basicSol
  }
  else
  {
    # Regular maximization basic solution
    # Checks whole column
    for (i in 1:ncol(basicSol))
    {
      column = tableau[,i]
      basicSol[1,i] = ifelse(((sum(column) == 1) && (max(column) == 1)), tableau[which.max(column),ncol(tableau)], 0)
    }
  }
  basicSol = round(basicSol, 2)
  
  return (t(basicSol))
}

# Simplex maximization
simplexMaximize <- function(tableau)
{
  simplexResult = list();
  iteration = 0;
  
  simplexResult$initial = list(iteration = iteration, tableau = tableau)
  simplexResult$feasible = TRUE
  
  
  # Main iteration
  while (TRUE)
  {
    lastRow = nrow(tableau)
    lastCol = ncol(tableau)
    
    # Finds the pivet column
    iPC = which.min(tableau[lastRow,])
    
    # If all pivot colum are not negative, stops
    if (tableau[lastRow, iPC] >= 0)
    {
      break
    }
    
    # Calculates test ratios
    pivotCol = tableau[-lastRow,iPC]
    RHS = tableau[-lastRow, lastCol]
    
    testRatio = RHS / pivotCol
    testRatio = ifelse(testRatio > 0, testRatio, Inf)
    
    
    # Finds the pivot row and element
    iPR = which.min(testRatio)
    pivotRow = tableau[iPR,]
    pivotE = tableau[iPR, iPC]
    
    
    # If not feasible, pivotE is zero
    if (pivotE <= 0)
    {
      simplexResult$feasible = FALSE
      return (simplexResult);
    }
    
    # Normalized pivot Row
    nPR = pivotRow / pivotE
    
    # Updates/Elimination 
    for (i in 1:lastRow)
    {
      if (i == iPR)
      {
        tableau[i,] = nPR
      }
      else
      {
        tableau[i,] = tableau[i,] - (nPR * tableau[i,iPC])
      }
    }
    
    # Update iteration counter and get basic solution
    iteration = iteration + 1;
    basicSol = getBasicSol(tableau, FALSE)
    
    simplexResult$perIterate = append(simplexResult$perIterate, list(iteration = iteration, tableau = tableau, basicSol = basicSol))
  }
  basicSol = getBasicSol(tableau, TRUE)
  simplexResult$final = list(iteration = iteration, tableau = tableau, basicSol = basicSol)
  
  return (simplexResult)
}

setUpTableu <- function(augcoeffmat)
{
  # Transpose the augcoeffmat
  augcoeffmat = t(augcoeffmat)
  
  # Adds the slack variables, change var names
  slack = diag(nrow(augcoeffmat))
  colnames(slack) = c(paste0("X", 1:(nrow(augcoeffmat)- 1)), "Z")
  
  tableau = cbind(augcoeffmat[,-ncol(augcoeffmat)], slack, augcoeffmat[,ncol(augcoeffmat)])
  
  colnames(tableau) = c(paste0("S", 1:(ncol(augcoeffmat) - 1)),
                       paste0("X", 1:(nrow(augcoeffmat) - 1)),
                        "Z",
                       "SOLUTION")
  
  # Negates objective function
  tableau[nrow(tableau), -(ncol(tableau) - 1)] = -tableau[nrow(tableau), -(ncol(tableau) - 1)]
  tableau[nrow(tableau), ncol(tableau)] = 0
  
  return (tableau)
}


# Setting up constraints
setUpConst <- function(augcoeffmat, foodNames, prices, nutrients, minimum, maximum, maxserve)
{
  augcoeffmat = rbind(augcoeffmat, -augcoeffmat) # binds negated rows for max nutrients
  
  rownames(augcoeffmat) = c(paste0("min_", nutrients), paste0("max_", nutrients)) 
  
  augcoeffmat = cbind(augcoeffmat, c(minimum, -maximum)) # binds serving minimum and -maximum of nutrients on RHS
  
  
  # creates an identity matrix with serving size constraint
  servConst = cbind(-diag(length(foodNames)), -maxserve) 
  rownames(servConst) = paste0("serv_", foodNames)
  
  # Creates objective function
  obj = matrix(c(prices, 1), nrow = 1)
  
  # Binds these together to set up augcoeffmatrix
  augcoeffmat = rbind(augcoeffmat, servConst, obj)
  
  colnames(augcoeffmat) = c(foodNames, "SOLUTION")
  
  return (augcoeffmat)
}


# Getting the augcoeffmat
getAugCoeff <- function(dataInput, minimum, maximum, maxserve)
{
  data = as.matrix(dataInput)
  
  # Extracts values from the dataInput
  foodNames = data[,1]
  prices = as.numeric(gsub("\\$", "", data[,2]))
  nutrients = colnames(data[,-(1:3)])
  
  if (is.null(nutrients))
  {
    nutrients = names(data[,-(1:3)])
  }
  
  
  # Removes unnecessary data (serving size, names, price/serving)
  data = matrix(as.numeric(data[,-(1:3)]), nrow = nrow(data))
  
  # Transposes to have the food names as colnames
  augcoeffmat = t(data)
  
  
  # Sets up constraints
  const_augcoeffmat = setUpConst(augcoeffmat, foodNames, prices, nutrients, minimum, maximum, maxserve)
  
  return (const_augcoeffmat)
}