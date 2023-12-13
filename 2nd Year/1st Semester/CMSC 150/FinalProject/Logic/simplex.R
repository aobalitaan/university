simplexMinimize <- function(dataInput, minimum, maximum, maxserve)
{
  augcoeffmat = getAugCoeff(dataInput, minimum, maximum, maxserve)
  dualTableu = setUpTableu(augcoeffmat)
  simplexResult = simplexMaximize(dualTableu)
  
  return (simplexResult)
}

getBasicSol <- function(tableu, isFinal)
{
  
  lastRow = nrow(tableu)
  lastCol = ncol(tableu)
  
  basicSol = matrix(NA, nrow = 1, ncol = ncol(tableu) - 1)
  foodNames = rownames(tableu)[-nrow(tableu)]
  sCount = lastCol - 2 - length(foodNames)  
  colnames(basicSol) = c(paste0("S", 1:sCount), foodNames, "COST")
  rownames(basicSol) = "SOLUTION"
  
  
  if (isFinal == TRUE)
  {
    
    basicSol[1,] = tableu[lastRow,-(lastCol-1)]

    basicSol = basicSol[, !grepl("^S\\d+$", colnames(basicSol))]
    
    basicSol = as.matrix(basicSol[-which(basicSol == 0)])
    colnames(basicSol) = "SOLUTION"
    basicSol = t(basicSol)
  }
  else
  {
    for (i in 1:ncol(basicSol))
    {
      column = tableu[,i]
      basicSol[1,i] = ifelse(((sum(column) == 1) && (max(column) == 1)), tableu[which.max(column),ncol(tableu)], 0)
    }
  }
  basicSol = round(basicSol, 2)
  
  return (t(basicSol))
}

simplexMaximize <- function(tableu)
{
  simplexResult = list();
  iteration = 0;
  
  simplexResult$initial = list(iteration = iteration, tableu = tableu)
  simplexResult$feasible = TRUE
  
  while (TRUE)
  {
    lastRow = nrow(tableu)
    lastCol = ncol(tableu)
    
    iPC = which.min(tableu[lastRow,])
    
    if (tableu[lastRow, iPC] >= 0)
    {
      break
    }
    
    pivotCol = tableu[-lastRow,iPC]
    
    RHS = tableu[-lastRow, lastCol]
    
    testRatio = RHS / pivotCol
    testRatio = ifelse(testRatio > 0, testRatio, Inf)
    
    iPR = which.min(testRatio)
    
    pivotRow = tableu[iPR,]
    
    pivotE = tableu[iPR, iPC]
    
    if (pivotE <= 0)
    {
      simplexResult$feasible = FALSE
      return (simplexResult);
    }
    
    nPR = pivotRow / pivotE
    
    for (i in 1:lastRow)
    {
      if (i == iPR)
      {
        tableu[i,] = nPR
      }
      else
      {
        tableu[i,] = tableu[i,] - (nPR * tableu[i,iPC])
      }
    }
    
    iteration = iteration + 1;
    basicSol = getBasicSol(tableu, FALSE)
    
    simplexResult$perIterate = append(simplexResult$perIterate, list(iteration = iteration, tableu = tableu, basicSol = basicSol))
  }
  basicSol = getBasicSol(tableu, TRUE)
  simplexResult$final = list(iteration = iteration, tableu = tableu, basicSol = basicSol)
  
  return (simplexResult)
}

setUpTableu <- function(augcoeffmat)
{
  augcoeffmat = t(augcoeffmat)
  
  slack = diag(nrow(augcoeffmat))
  colnames(slack) = c(paste0("X", 1:(nrow(augcoeffmat)- 1)), "Z")
  
  tableu = cbind(augcoeffmat[,-ncol(augcoeffmat)], slack, augcoeffmat[,ncol(augcoeffmat)])
  
  colnames(tableu) = c(paste0("S", 1:(ncol(augcoeffmat) - 1)),
                       paste0("X", 1:(nrow(augcoeffmat) - 1)),
                        "Z",
                       "SOLUTION")
  
  tableu[nrow(tableu), -(ncol(tableu) - 1)] = -tableu[nrow(tableu), -(ncol(tableu) - 1)]
  tableu[nrow(tableu), ncol(tableu)] = 0
  
  return (tableu)
}

setUpConst <- function(augcoeffmat, foodNames, prices, nutrients, minimum, maximum, maxserve)
{
  augcoeffmat = rbind(augcoeffmat, -augcoeffmat)
  
  rownames(augcoeffmat) = c(paste0("min_", nutrients), paste0("max_", nutrients))
  
  augcoeffmat = cbind(augcoeffmat, c(minimum, -maximum))
  
  servConst = cbind(-diag(length(foodNames)), -maxserve)
  rownames(servConst) = paste0("serv_", foodNames)
  
  obj = matrix(c(prices, 1), nrow = 1)
  
  augcoeffmat = rbind(augcoeffmat, servConst, obj)
  
  colnames(augcoeffmat) = c(foodNames, "SOLUTION")
  
  return (augcoeffmat)
}

getAugCoeff <- function(dataInput, minimum, maximum, maxserve)
{
  data = as.matrix(dataInput)
  foodNames = data[,1]

  prices = as.numeric(gsub("\\$", "", data[,2]))
  nutrients = colnames(data[,-(1:3)])
  
  if (is.null(nutrients))
  {
    nutrients = names(data[,-(1:3)])
  }
  
  data = matrix(as.numeric(data[,-(1:3)]), nrow = nrow(data))
  
  augcoeffmat = t(data)
  
  const_augcoeffmat = setUpConst(augcoeffmat, foodNames, prices, nutrients, minimum, maximum, maxserve)
  
  return (const_augcoeffmat)
}