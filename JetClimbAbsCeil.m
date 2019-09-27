function error = JetClimbAbsCeil(h,rho)

[T p rho_new]=StdAtm(h);
error = rho - rho_new;
