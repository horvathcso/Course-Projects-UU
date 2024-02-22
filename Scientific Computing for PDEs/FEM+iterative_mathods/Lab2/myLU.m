tic
[L,U]=lu(A);
toc

figure(1),clf                    %Plot the results
spy(A)
set(gca,'XGrid','on','YGrid','on','GridLineStyle',':')
title('The nonzero structure of A')

figure(2),clf                    %Plot the results
spy(L)
set(gca,'XGrid','on','YGrid','on','GridLineStyle',':')
title('The nonzero structure of L')

figure(3),clf                    %Plot the results
spy(U)
set(gca,'XGrid','on','YGrid','on','GridLineStyle',':')
title('The nonzero structure of U')

