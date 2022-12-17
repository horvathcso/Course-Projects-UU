%% T1
f=[2,2,2,3,4,3];
A=[-1,0,0,0,0,-1;  -1,-1,0,0,0,0;  0,-1,-1,0,0,0;  0,0,-1,-1,0,0;  0,0,0,-1,-1,0;  0,0,0,0,-1,-1];
b =[-700, -500, -600, -300, -100, -50];

x = intlinprog(f,[1,2,3,4,5,6],A,b,[],[],[0,0,0,0,0,0])
f*x

%% T2
f=[2,2,2,3,4,3];
A=[-1,0,0,0,0,-1;  -1,-1,0,0,0,0;  0,-1,-1,0,0,0;  0,0,-1,-1,0,0;  0,0,0,-1,-1,0;  0,0,0,0,-1,-1];
b =[-700, -250, -600, -300, -100, -50];

x = intlinprog(f,[1,2,3,4,5,6],A,b,[],[],[0,0,0,0,0,0])

%% T1
f=[2,2,2,3,4,3];
A=[-1,0,0,0,0,-1;  -1,-1,0,0,0,0;  0,-1,-1,0,0,0;  0,0,-1,-1,0,0;  0,0,0,-1,-1,0;  0,0,0,0,-1,-1];
b =[-700, -500, -600, -300, -100, -50];

%options = optimoptions('linprog','Simplex','on','LargeScale','off');
options = optimset('Algorithm','interior-point','Diagnostics', 'on', 'LargeScale', 'on');
x = linprog(f,A,b,[],[],[0,0,0,0,0,0],[],options)
f*x


