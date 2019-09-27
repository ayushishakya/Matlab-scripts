% ************************************************************************
% This function determines climbing and descending flight performances of a 
% jet aircraft
% ************************************************************************

clear; % Clear workspace
clc; % Clean workspace
% close all; % Close all figures

% Jet aircraft details
W=325000; % weight in N with a full fuel tank
S=90;  % planform area in m^2
CD0=0.015; 
K=0.05; 
CLmax=2.8;
AR = 5.9;

Tamax=56000; % maximum thrust available in N
beta=0.6;
% % SFC
c = 0.69; % unit: (N/N-hr)
c = c/3600; %unit: s^(-1)

% Aircraft has a climb angle of 3 degrees at 10000 ft altitude

gamma = 3*pi/180;
hg = 3.048; % in km 
[T p rho]=StdAtm(hg); % Get density from the standard atmosphere
rho_s = 1.225; % Sea level air density in kg/m^3

gamma=3*pi/180;
Vstall = sqrt(2*W*cos(gamma)/(rho*S*CLmax));
% Thrust required curve
V=linspace(Vstall-10,300,500);

% Drag
D=1/2*rho*V.^2*S*CD0+2*K*W^2/rho./V.^2/S;
figure;
plot(V,D,'g');
ylabel('Thrust Required and Drag for Climbing Flight (N)'); xlabel('Velocity (m/s)');

% Thrust required
hold on;
Tr = W*gamma + D;
plot(V,Tr,'m');grid on;

% Thrust available
hold on;
plot(Tamax*(rho/rho_s)^beta*ones(300,1));
legend('Drag','Thrust Required','Maximum Available Thrust');

% Minimum thrust required
Trmin = W*gamma + 2*W*sqrt(K*CD0)
% throttle setting
delta = Trmin/Tamax*(rho_s/rho)^beta

% Maximum climb angle
Ta = Tamax*(rho/rho_s)^beta; Em = 1/(2*sqrt(K*CD0));
zmax = Ta/W*Em;
gamma_max = 180/pi*asin((zmax - 1)/Em)

% Maximum rate of climb
VR = sqrt(2*W/(rho*S))*(K/CD0)^0.25;
um = sqrt((zmax + sqrt(zmax^2 + 3))/3)
RC_max = 1/(2*Em)*(2*zmax*um - (um^3 + 1/um))*VR

% Absolute ceiling
Ta = W/Em;
rho = (Ta/Tamax)^(1/beta)*rho_s;
[hmax,f_val,exit_flag,output] = fsolve(@(h) JetClimbAbsCeil(h, rho), 3.048);

% Plot RC_max with altitude
h = linspace (0,hmax,500);
for k=1:size (h,2)
    [T p rho]=StdAtm(h(k)); % get density
    Ta = Tamax*(rho/rho_s)^beta;
    zmax = Ta/W*Em;
    VR = sqrt(2*W/(rho*S))*(K/CD0)^0.25;
    um = sqrt((zmax + sqrt(zmax^2 + 3))/3);
    RC_max(k) = 1/(2*Em)*(2*zmax*um - (um^3 + 1/um))*VR;
end

figure;
plot(RC_max, h); grid on;
ylabel('Altitude (km)'); xlabel('Maximum Rate of Climb with Full Throttle (m/s)');


% Climbing flight envelope at gamma = 3 deg
gamma=3*pi/180;
h=linspace(0,hmax/2,500);
for k=1:size(h,2)
  [T p rho]=StdAtm(h(k));
  % Tr = W*gamma + D; Tr = Tamax*(rho/rho_s)^beta;
  % Tr = W*gamma + 1/2*rho*V.^2*S*CD0+2*K*W^2/rho./V.^2/S = Tr = Tamax*(rho/rho_-s)^beta;
  speed_sol=sort(roots([1/2*rho*S*CD0 0 W*gamma-Tamax*(rho/rho_s)^beta 0 2*K*W^2/rho/S]));
  min_flag = 0;
  % Extract real solutions
  for index = 1:4
      if(isreal(speed_sol(index)))
          if(speed_sol(index) > 0)
              if(min_flag == 0)
                  Vmin(k) = speed_sol(index);
                  min_flag = 1;
              else
                  Vmax(k) = speed_sol(index);
              end
          end
      end
  end
  if(min_flag == 0)
      % Save height for which speed solutions exist
      new_h = h(1:k-1);
      break;
  end    
  Vstall(k)=sqrt(2*W*cos(gamma)/rho/S/CLmax);  
end
Vmin_mod=max(Vmin,Vstall);

figure;
patch([Vmin_mod Vmax(end:-1:1)],[new_h new_h(end:-1:1)],[0.8 1 1]);
hold on;
plot(Vmax,new_h,Vmin,new_h,Vstall,new_h);
grid on;
xlim([0 300]);
xlabel('Velocity (m/s)');
ylabel('Altitude (km)');

% Thrust required and descending flight envelope
gamma = -2*pi/180;
hg = 3.048; % in km 
[T p rho]=StdAtm(hg); % Get density from the standard atmosphere

Vstall = sqrt(2*W*cos(gamma)/(rho*S*CLmax));
% Thrust required curve
V=linspace(Vstall-10,300,500);

% Drag
D=1/2*rho*V.^2*S*CD0+2*K*W^2/rho./V.^2/S;
figure;
plot(V,D,'g');
ylabel('Thrust Required and Drag for Descending Flight (N)'); xlabel('Velocity (m/s)');

% Thrust required
hold on;
Tr = W*gamma + D;
plot(V,Tr,'m');grid on;

% Thrust available
hold on;
plot(Tamax*(rho/rho_s)^beta*ones(300,1));
legend('Drag','Thrust Required','Maximum Available Thrust');

% Minimum thrust required
Trmin = W*gamma + 2*W*sqrt(K*CD0)
% throttle setting
delta = Trmin/Tamax*(rho_s/rho)^beta

% Flight envelope

gamma=-2*pi/180;
h=linspace(0,30,500);
clear Vmin Vmax Vstall new_h; % Clear variables
for k=1:size(h,2)
  [T p rho]=StdAtm(h(k));
  % Tr = W*gamma + D; Tr = Tamax*(rho/rho_s)^beta;
  % Tr = W*gamma + 1/2*rho*V.^2*S*CD0+2*K*W^2/rho./V.^2/S = Tr = Tamax*(rho/rho_-s)^beta;
  speed_sol=sort(roots([1/2*rho*S*CD0 0 W*gamma-Tamax*(rho/rho_s)^beta 0 2*K*W^2/rho/S]));
  min_flag = 0;
  % Extract real solutions
  for index = 1:4
      if(isreal(speed_sol(index)))
          if(speed_sol(index) > 0)
              if(min_flag == 0)
                  Vmin(k) = speed_sol(index);
                  min_flag = 1;
              else
                  Vmax(k) = speed_sol(index);
              end
          end
      end
  end
  if(min_flag == 0)
      break;
  else
      % Save height for which speed solutions exist
      new_h(k) = h(k);
  end    
  Vstall(k)=sqrt(2*W*cos(gamma)/rho/S/CLmax);  
end

    
Vmin_mod=max(Vmin,Vstall);

figure;
patch([Vmin_mod Vmax(end:-1:1)],[new_h new_h(end:-1:1)],[0.8 1 1]);
hold on;
plot(Vmax,new_h,Vmin,new_h,Vstall,new_h);
grid on;
xlim([0 700]);
xlabel('Velocity (m/s)');
ylabel('Altitude (km)');

% Climbing and descending flight envelope boundary for different flight path angles
gamma=linspace(-2*pi/180,5*pi/180,40);
h=linspace(0,27,500);
clear Vmin Vmax Vstall new_h; % Clear variables
for i = 1:length(gamma)
    i
    [hmax(i),f_val,exit_flag,output] = fsolve(@(h) JetEqnAbsCeil(h, gamma(i)), 3.048); % km
    clear h;
    h = linspace(0,hmax(i)-0.00001,500);
    for k=1:size(h,2)
        [T p rho]=StdAtm(h(k));
        % Tr = W*gamma + D; Tr = Tamax*(rho/rho_s)^beta;
        % Tr = W*gamma + 1/2*rho*V.^2*S*CD0+2*K*W^2/rho./V.^2/S = Tr = Tamax*(rho/rho_-s)^beta;
        speed_sol=sort(roots([1/2*rho*S*CD0 0 W*gamma(i)-Tamax*(rho/rho_s)^beta 0 2*K*W^2/rho/S]));
        min_flag = 0;
        % Extract real solutions
        for index = 1:4
            if(isreal(speed_sol(index)))
                if(speed_sol(index) > 0)
                    if(min_flag == 0)
                        Vmin(i,k) = speed_sol(index);
                        min_flag = 1;
                    else
                        Vmax(i,k) = speed_sol(index);
                    end
                end
            end
        end
        if(min_flag == 0)
            Vmin(i,k:length(h)) = NaN;
            Vmax(i,k:length(h)) = NaN;
            Vstall(i,k:length(h)) = NaN;
            new_h(i,k:length(h)) = NaN;
            break;
        else
            % Save height for which speed solutions exist
            new_h(i,k) = h(k);
        end
        Vstall(i,k)=sqrt(2*W*cos(gamma(i))/rho/S/CLmax);
    end
end

Vmin_mod=max(Vmin,Vstall);
figure;
surf(Vmax ,gamma*180/pi,new_h,'LineStyle','none');
hold on;
surf(Vmin_mod,gamma*180/pi,new_h,'LineStyle','none');
xlabel('Velocity (m/s)');
ylabel('Flight path angle (deg)');
zlabel('Altitude (km)');