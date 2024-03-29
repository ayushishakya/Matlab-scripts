% wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
function [planet1, planet2, trajectory] = interplanetary(depart, arrive)
% wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
%{
This function determines the spacecraft trajectory from the sphere
of influence of planet 1 to that of planet 2 
dum - a dummy vector not required in this procedure
jd1, jd2 - Julian day numbers at departure and arrival
tof - time of flight from planet 1 to planet 2 (s)
depart - [planet_id, year, month, day, hour, minute, second] at departure
arrive - [planet_id, year, month, day, hour, minute, second] at arrival
planet1 - [Rp1, Vp1, jd1]
planet2 - [Rp2, Vp2, jd2]
trajectory - [V1, V2]
%}
% --------------------------------------------------------------------
global mu
planet_id = depart(1);
year = depart(2);
month = depart(3);
day = depart(4);
hour = depart(5);
minute = depart(6);
second = depart(7);
%obtain planet 1's state vector (don't need its orbital elements ["dum"]):
[dum, Rp1, Vp1, jd1] = planet_elements_and_sv (planet_id, year, month, day, hour, minute, second);

planet_id = arrive(1);
year = arrive(2);
month = arrive(3);
day = arrive(4);
hour = arrive(5);
minute = arrive(6);
second = arrive(7);
% obtain planet 2's state vector:
[dum, Rp2, Vp2, jd2] = planet_elements_and_sv (planet_id, year, month, day, hour, minute, second);

tof = (jd2 - jd1)*24*3600;
%Patched conic assumption:
R1 = Rp1;
R2 = Rp2;
%find the spacecraft's velocity at departure and arrival, assuming a prograde trajectory:
[V1, V2] = lambert(R1, R2, tof, 'pro');
planet1 = [Rp1, Vp1, jd1];


planet2 = [Rp2, Vp2, jd2];
trajectory = [V1, V2];
end %interplanetary
