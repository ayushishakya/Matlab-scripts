%{
A = input("A:");
B = input("B:");
C = input("C:");
D = input("D:");
%}
%system matrix
A = [-1 0; 0 -1];
ranksys = rank(A);

%control matrix
B = [1 0; 0 1];

%output matrix
C = [-1 1];
D = [2 1];



disp("System: ");
sys = ss(A, B, C, D);
display(sys);

ctr = ctrb(A,B);
rankc = rank(ctr);
fprintf("Controllability matrix rank: %i \n", rankc);
disp(ctr);
if (rankc == ranksys)
    disp("System is controllable");
    %desired eigen values
    P = input ("Desired eigen values\n");     %[-1 -1 -2];

    %controller gain for desired eigen values
    K = place(A, B, P);
    disp("Feedback matrix: ");
    disp(K);
else
    disp("System is not controllable");
end

obs = obsv(A,C);
ranko = rank(obs);
fprintf("\nObservability matrix rank: %i \n", ranko);
disp(obs);

if (ranko == ranksys)
    disp("System is observable");
    %full order observer gain
    poles = input("Desired observer eigen value\n");    %[-1 -2 -1];
    Fullobsgain = place(A', C', poles);
    display(Fullobsgain);

else
    disp("System not observable");
end

H = tf(sys);
disp("Transfer function of the system");
display(H);
sysr = minreal(sys);
Hr = tf(sysr);

equality = isequal(H,Hr);
if (equality==true)
    disp("realisation is minimum");
else
    disp("realisation is not minimum");
end

disp("Markov parameters: ");
oc = obs*ctr;
display(oc);

disp("Reduced order system state");
display(sysr);
poles = input("Reduced order observer poles\n");
obsgain = place(sysr.A', sysr.C', poles);
disp("Reduced order observer gain matrix: ");
display(obsgain);
