

%Initialize z_guess
initialization = 1;

if (initialization == 0)
    Z_guess = zeros(14,1);
    Z_guess(1) = 85;
    
else
    load trim_values_straight_level
    Z_guess = [XStar;UStar];
end

%solve 
[ZStar,f0] = fminsearch('cost_straight_level',Z_guess,...
    optimset('TolX', 1e-10,'MaxFunEvals', 10000, 'MaxIter', 10000))
 
XStar = ZStar(1:9);
UStar = ZStar(10:14);

XdotStar = RCAM_plant(XStar,UStar)
VaStar = sqrt(XStar(1)^2 + XStar(2)^2 + XStar(3)^2)
alphaStar = XStar(8) - atan2(XStar(3),XStar(1))
vStar = XStar(2)
phiStar = XStar(7)
psiStar = XStar(9)

save trim_values_straight_level XStar UStar
