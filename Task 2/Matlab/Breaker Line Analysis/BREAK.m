function [ H_Breaker, h_breaker, Ks ] = BREAK(T, theta_o, Ho, m, bo, b)
%BREAK OMGWTFBBQ
%   Input:
%       T = wave period, sec.
%       theta_o = deep water incident wave angle
%       Ho = deep water wave height, m.
%       m = beach slope, to be found in the     
      EPS   = 0.000001;
      ITERM = 50;                                                                             
      ITER  = 0;  
      Err = 1;
%Definition of Constants
g = 9.81;
Kr = 1;
Hb = 1;
kappa_s = 0.78;
omega = (2*pi)./T;
a = 43.8*(1 - exp(-19*m));
b = 1.56*(1 + exp(-19.5*m))^-1;
%Iterating to solve for breaker depth, wave height, distance from shore
      while ((abs(Err) > EPS) & (ITER <= ITERM))
        hb = (g^(1/5)./kappa_s^(4/5)).*((Ho.^2)./(2*omega)).^(2/5);
        L_break = ldis(T,hb);
        %Shoaling Coefficient Evaluation
        Kr = SHOAL(L_break,hb);
        %Refraction Coefficient Evaluation
        Ks = REFRA(bo, b);
        %Iteration of Hb
        Hb_iter = Ho*Ks*Kr;
        kappa_iter = b - a*(Hb_iter / (g*T^2));
        Err = (Hb_iter - Hb)/Hb;
        ITER = ITER + 1;
        kappa_s = kappa_iter;
      end
      H_Breaker = Hb_iter;
      h_breaker = hb;
end

