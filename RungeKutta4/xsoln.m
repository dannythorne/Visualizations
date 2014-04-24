function [x] = xsoln( t)
 %a = 1.3;
 %b = 0.0;
 %c = 2.0;
 %x = a*((t+b).*c).*exp(-((t+b).*c).^2);
  %a = 4.0 ;
  %b = 0.05;
  %c = 8.0 ;
  %x = b*(-((-a*t+2.0)).*exp((-a*t+2.0))-exp((-a*t+2.0))-c) - b*(-3.0*exp(2.0)-c);
  x = 2*exp(-3*t) + 2*t - 1;
end
