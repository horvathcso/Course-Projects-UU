function G=JacobiMatrix(A)
  M = diag(diag(A));
  G = M\(M-A);