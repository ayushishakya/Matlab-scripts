clear all;
clc;
%% Taking Inputs
load('Input_data.mat');
load('Output_data.mat');
SCmin = -0.5;
SCmax = 0.5;
[n nI] = size(Input_data);
[m nO] = size(Output_data);
Smax = max([Input_data Output_data]);
Smin = min([Input_data Output_data]);
Scale_Fac = (SCmax - SCmin)./(Smax - Smin) ;
%% Activation Functions
f = @(A) tanh(A) ;
g = @(B) sech(B).*sech(B) ;    %Derivative of f (Activation Function)
%% Scaling the Inputs 
for i = 1:nI
    Input(:,i) = SCmin + (Input_data(:,i) - Smin(i))*Scale_Fac(i);
end

for i = 1:nO
    Output(:,i) = SCmin + (Output_data(:,i) - Smin(i+nI))*Scale_Fac(i+nI);
end
%% Training the weights 
Mu = 0.1;          %Learning Rate
W1 = SCmin + (SCmax - SCmin)*rand(3,2);
W2 = SCmin + (SCmax - SCmin)*rand(2,3);
z = Output;
for j = 1:100
    for i = 1:n
        u0 = Input(i,:)';
%         z = Output(i,:)';
        y1 = W1*u0;
        u1 = f(y1);
        y2 = W2*u1;
        u2 = f(y2);

        e2b = g(y2).*(z(i,:)' - u2);
        e1b = g(y1).*(W2'*e2b);

        W1 = W1 + Mu*e1b*u0';
        W2 = W2 + Mu*e2b*u1';
    end

    error = 0;

    for i = 1:n     
        
        Temp = f(W1*Input(i,:)');
        Output(i,:) = f(W2*Temp)';

        error = error + max(abs(z(i,:)' - Output(i,:)'));
    end
     if(error<0.1)
         break;
     end
end
%% Descaling the Output
for i = 1:nO 
    DSOutput(:,i) = Smin(i+nI) + (Output(:,i)-SCmin)/Scale_Fac(i+nI);
end
%% Plots
plot(Input_data(:,2),Output_data(:,2),'b')
hold on 
plot(Input_data(:,2),DSOutput(:,2),'r')
title('Output vs Input')
xlabel('Input Data')
ylabel('Output Data')
legend('Actual Data','Trained Data')