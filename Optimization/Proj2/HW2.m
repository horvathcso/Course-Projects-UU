clear all
clc
opts = detectImportOptions('wdbc.data.txt');
data = readtable('wdbc.data.txt',opts);

y0=table2array(data(:,2));
m = length(y0); % # of data points
n = 30;% # of features
C = 1000;% 10 works really well, but 0 is best?
y=zeros(m,1);
for i=1:m
    if strcmp(y0(i),'M')
        y(i)= 1;
    else
        y(i)=-1;
    end
end
clear y0


% dividing in training and test data
m=350;
s=size(data,1);
idx=randperm(s);
xtrain = table2array(data(idx(1:m),3:32));
ytrain = y(idx(1:m));
xtest = table2array(data(idx(m+1:end),3:32));
ytest = y(idx(m+1:end));

m=length(ytrain);

% setting up matrices for A*X <= R
R = -1*ones(m,1);           % RHS of constraints (m x 1)
X = [xtrain ones(m,1)];     % x data and ones for multiplication with b (m x n+1)
Y = ones(n+1,m).*ytrain';   % y_i needs to be multiplied with each x_i (n entries) and b (m x n+1)
Y=Y';
A = X.*Y;                   % elementwise multiplication

Cm = eye(m,m);            % including multiplication with C for 
A = -1*[A Cm];              % epsilon term in A
%H = eye(n+1+m);
%H(n+1:end,:) = zeros(m+1,n+1+m);
H = [eye(n),zeros(n,m+1);
     zeros(m+1,n+m+1)];     % constructing H for obj function

ind=1;
NumberOfIntervals=30;
accuracy= [];
for C=logspace(log10(1),log10(10^6),NumberOfIntervals+1)
f = [zeros(n+1,1); ones(m,1)*C];    % for epsilon term in obj function
lb = [ones(n+1,1)*-inf;zeros(m,1)]; % include lower bound for epsilons

[z,fval] = quadprog(H,f,A,R,[],[],lb,[]);

omega = z(1:n);
b = z(n+1);
epsilon = z(n+2:end);



%% test data
ypredict = zeros(length(ytest),1);
true = 0;
false = 0;
for i=1:length(ytest)
    LHS = omega'*xtest(i,:)'+b;
    if LHS >= 1
        ypredict(i) = 1;
    else
        ypredict(i) = -1;
    end

    if ypredict(i) == ytest(i)
        true = true + 1;
    else
        false = false +1;
    end
end
accuracy(ind)=true/(true+false);
ind=ind+1;
end
semilogx(logspace(log10(1),log10(10^9),NumberOfIntervals+1),accuracy)
title(join(["Testing different C values with ",m ," training data"]))

