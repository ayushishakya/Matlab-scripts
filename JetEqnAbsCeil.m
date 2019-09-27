function error = JetEqnAbsCeil(h,gamma)

W = 325000; K = 0.05; CD0 = 0.015; Tamax = 56000; beta = 0.6;
[Th ph rho]=StdAtm(h);
error=W*gamma + 2*W*sqrt(K*CD0)-Tamax*(rho/1.225)^beta;