function ut = RHS_P(L,U,Q,V)
  y=-L\(Q*V);
  ut=U\y;
end

