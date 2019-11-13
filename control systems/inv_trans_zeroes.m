%{
A = input("A:");
B = input("B:");
C = input("C:");
D = input("D:");
%}
%system matrix
A = [1 0 0; 0 5 0; 0 0 2];
ranksys = rank(A);

%control matrix
B = [1 0; 0 1; 1 0];

%output matrix
C = [1 1 1];
D = zeros(size(C, 1),size(B,2));

disp("System: ");
sys = tf([4.2,0.25,-0.004],[1,9.6,17]);
%sys = ss(A, B, C, D);

display(sys);

invz = tzero(sys);
disp("Invariant zeroes: ");
display(invz);

trz = tzero(minreal(sys));
disp("Transmission zeroes: ");
display(trz);

%pole zero map
[p, z] = pzmap(sys)
