% wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
function [month, planet] = month_planet_names(month_id, planet_id)
% wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww


%{
This function returns the name of the month and the planet
corresponding, respectively, to the numbers "month_id" and
"planet_id".
months - a vector containing the names of the 12 months
planets - a vector containing the names of the 9 planets
month_id - the month number (1 - 12)
planet_id - the planet number (1 - 8)
%}
% ------------------------------------------------------------------
months = ['January  '
          'February '
          'March    '
          'April    '
          'May      '
          'June     '
          'July     '
          'August   '
          'September'
          'October  '
          'November '
          'December '];
planets = ['Mercury'
           'Venus  '
           'Earth  '
           'Mars   '
           'Jupiter'
           'Saturn '
           'Uranus '
           'Neptune'];

month = months (month_id, 1:9);
planet = planets(planet_id, 1:7);
% wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
end