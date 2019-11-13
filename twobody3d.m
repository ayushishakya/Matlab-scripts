function twobody3d
%{
This function solves the inertial two-body problem in three dimensions
numerically using the RKF4(5) method.
G - universal gravitational constant 
m1,m2 - the masses of the two bodies (kg)
m - the total mass (kg)
t0 - initial time (s)
tf - final time (s)
R1_0,V1_0 - initial position (km) and velocity (km/s) of m1
R2_0,V2_0 - initial position (km) and velocity (km/s) of m2
y0 - initial values of the state vectors of the two bodies:[R1_0; R2_0; V1_0; V2_0]
t -time
X1,Y1,Z1 - m1 coordinates

X2,Y2,Z2 -m2 coordinates
VX1, VY1, VZ1 - velocity of m1 
VX2, VY2, VZ2 - velocity of m2 
y - a matrix whose 12 columns are, respectively,
X1,Y1,Z1; X2,Y2,Z2; VX1,VY1,VZ1; VX2,VY2,VZ2
XG,YG,ZG center of mass 

%}
% ----------------------------------------------------------------------
clc; clear all; close all
G = 6.67259e-20;
%Input data:
m1 = 1.e26;
m2 = 1.e26;
t0 = 0;
tf = 480;
R1_0 = [ 0; 0; 0];
R2_0 = [3000; 0; 0];
V1_0 = [ 10; 20; 30];
V2_0 = [ 0; 40; 0];



y0 = [R1_0; R2_0; V1_0; V2_0];

[t,y] = rkf45(@rates, [t0 tf], y0);

output
return

function dydt = rates(t,y) %acc
R1 = [y(1); y(2); y(3)];
R2 = [y(4); y(5); y(6)];
V1 = [y(7); y(8); y(9)];
V2 = [y(10); y(11); y(12)];
r = norm(R2 - R1);
A1 = G*m2*(R2 - R1)/r^3;
A2 = G*m1*(R1 - R2)/r^3;
dydt = [V1; V2; A1; A2];
end %rates

function output %trajectory of the center of mass 

X1 = y(:,1); Y1 = y(:,2); Z1 = y(:,3);
X2 = y(:,4); Y2 = y(:,5); Z2 = y(:,6);
XG = []; YG = []; ZG = [];
for i = 1:length(t)
XG = [XG; (m1*X1(i) + m2*X2(i))/(m1 + m2)];
YG = [YG; (m1*Y1(i) + m2*Y2(i))/(m1 + m2)];
ZG = [ZG; (m1*Z1(i) + m2*Z2(i))/(m1 + m2)];
end
%plot
figure (1)
title('Motion relative to the inertial frame');
hold on
plot3(X1, Y1, Z1, '-r')
plot3(X2, Y2, Z2, '-g')
plot3(XG, YG, ZG, '-b')
common_axis_settings
figure (2)
title('Motion of m2 and G relative to m1')
hold on
plot3(X2 - X1, Y2 - Y1, Z2 - Z1, '-g')
plot3(XG - X1, YG - Y1, ZG - Z1, '-b')
common_axis_settings
figure (3)
title('Motion of m1 and m2 relative to G')
hold on
plot3(X1 - XG, Y1 - YG, Z1 - ZG, '-r')
plot3(X2 - XG, Y2 - YG, Z2 - ZG, '-g')
common_axis_settings

function common_axis_settings

text(0, 0, 0, 'o')
axis('equal')
view([2,4,1.2])
grid on
axis equal
xlabel('X (km)')
ylabel('Y (km)')
zlabel('Z (km)')
end %common_axis_settings
end %output
end %twobody3d
