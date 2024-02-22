function [H,Q,M]   = Periodic_E_SC_Variable(L,n,order)
    h = L/n;
    switch order
        case 12
            [H, Q, M] = implementations.Periodic_E_SC_Variable_12(n,h);
        case 10
            [H, Q, M] = implementations.Periodic_E_SC_Variable_10(n,h);
        case 8
            [H, Q, M] = implementations.Periodic_E_SC_Variable_8(n,h);
        case 6
            [H, Q, M] = implementations.Periodic_E_SC_Variable_6(n,h);
        case 4
            [H, Q, M] = implementations.Periodic_E_SC_Variable_4(n,h);        
        case 2
            [H, Q, M] = implementations.Periodic_E_SC_Variable_2(n,h);    
        otherwise
            error('Invalid operator order %d.',order);
    end
end
