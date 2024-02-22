function ut = RHS_P3(Q,M_RV,V)
    ut=-(Q*(1/2*V.^2) + M_RV*V);
end
  
  