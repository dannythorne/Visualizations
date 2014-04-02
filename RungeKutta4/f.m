function [xp] = f( t, x)
 %a = 1.3;
 %b = 0.0;
 %c = 2.0;
 %xp = a*c.*exp(-c^2*(t+b).^2) ...
 %   - 2*a*((t+b).^2).*(c^3.*exp(-c^2*((t+b).^2)));
  %a = 4.0 ;
  %b = 0.05;
  %c = 8.0 ;
  %xp = -x-b*(-4*a*exp(-a*t+2)+a^2*exp(-a*t+2).*t-exp(-a*t+2)*a.*t+3*exp(-a*t+2)+c) - b*(-3.0*exp(2.0)-c);
  xp = -3*x + 6*t - 1;
end
