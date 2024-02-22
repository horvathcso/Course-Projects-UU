function G=GaussSeidelMatrix(A)
  M = tril(A);
  G = M\(M-A);