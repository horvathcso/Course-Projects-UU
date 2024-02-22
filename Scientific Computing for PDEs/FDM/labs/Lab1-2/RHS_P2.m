function ut = RHS_P2(L,U,Q,V)
  y=-L\(Q*(1/2*V.^2));
  ut=U\y;
end

