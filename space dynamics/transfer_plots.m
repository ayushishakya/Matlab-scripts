n = [5, 8, 10, 11, 15, 40, 60];
%hohmann transfer
dVh = (sqrt(2*n/(n+1)) -1) + (1 - sqrt(2/(n+1)))/sqrt(n);

%bi-elliptic transfer
dVb = (sqrt(2) - 1)*(1 + 1/sqrt(n));

plot(dVh, dVb, n);
xlabel(n);
ylabel(del_v/vA);
hold on;