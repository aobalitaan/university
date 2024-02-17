# AXEL O. BALITAAN
# 2022-05153
# CMSC 150 - B2L

#Given Matrix
mat = matrix(c(3,4,2,-2,-2,1,1,6,3), nrow = 3, ncol = 3, byrow = FALSE)

#Checks if square matrix
SquareMatrix <- function(mat)
{
  #compares column and row dimension
  return (ncol(mat) == nrow(mat))
}

#Gets the minor of the matrix using the row/column, returns the determinant of such
MatrixMinor <- function(mat, i, j)
{
  #removes ith row and jth column, then calculates determinant
  if (nrow(mat) > 2)
  {
    return(det(mat[-i,-j]))
  }
  #Case for 2x2 matrix, returns just the value left
  return(mat[-i,-j])
}

#Calculates a matrix's cofactor (minor's cofactor)
MatrixCofactor <- function(mat, i, j)
{
  return (((-1)^(i+j))*(mat))
}

#Gets the adjoint of a matrix
MatrixAdjoint <- function(mat)
{
  #Checks if it is a square
  if (SquareMatrix(mat) == FALSE)
  {
    #if not a square returns NA
    return (NA)
  }
  #If a square returns the adjoint of the matrix
  return (t(mat))
}

#Gets the inverse of a matrix
MatrixInverse <- function(mat)
{
  #If the matrix is not a square early returns NA
  if (SquareMatrix(mat) == FALSE)
  {
    #if not a square returns NA
    return (NA)
  }
  
  #Case for a 1x1 matrix
  if (ncol(mat) == 1)
  {
    #Just return the reciprocal of the value in the matrix
    mat_inverse = matrix(c(1/mat[1,1]), nrow = 1, ncol = 1);
    return (mat_inverse)
  }
  
  #If a square continues with the function
  #Sets a range of how many iterations same with "mat_range = 1:ncol(mat)"
  mat_range = 1:nrow(mat)
  
  #Initialize an empty matrix for the cofactor of the matrix
  mat_cofactor = matrix(nrow = nrow(mat), ncol = ncol(mat))
  
  #Loops (nested) using the given dimensions
  for (i in mat_range)
  {
    for (j in mat_range)
    {
      #Gets specific minor and determinant
      mat_minor = MatrixMinor(mat, i, j)
      #Gets cofactor value
      mat_cofactor_value = MatrixCofactor(mat_minor, i , j)
      #Puts the cofactor value in the cofactor matrix
      mat_cofactor[i,j] = mat_cofactor_value
    }
  }
  
  #Transposes the cofactor matrix (gets the adjoint)
  mat_adjoint = MatrixAdjoint(mat_cofactor)
  #Calculate determinant amount
  mat_det = det(mat)
  
  
  #If the det is to return an inf value
  if (mat_det == 0)
  {
    return ("NO INVERSE");
  }
  
  #Gets the inverse of the matrix
  mat_inverse = (1/mat_det) * mat_adjoint
  
  #returns the inverse of the matrix
  return(mat_inverse)
}

MatrixInverse(mat)