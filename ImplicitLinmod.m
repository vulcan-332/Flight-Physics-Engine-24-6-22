function [E,A_P,B_P] = ImplicitLinmod(MY_FUN, XDOTo, Xo, Uo, DXDOT, DX, DU)

%obtain number of states and controls 
n=length(XDOTo);
m=length(Uo);

E = zeros(n,n);

for i=1:n
    for j=1:n
        dxdot = DXDOT(i,j);
        
        xdot_plus = XDOTo;
        xdot_minus = XDOTo;
        
        xdot_plus(j) = xdot_plus(j) + dxdot;
        xdot_minus(j) = xdot_minus(j) - dxdot;
        
        F = feval(MY_FUN, xdot_plus,Xo,Uo);
        F_plus_keep = F(i);
        
        F = feval(MY_FUN, xdot_minus,Xo,Uo);
        F_minus_keep = F(i);
        
        E(i,j) = (F_plus_keep - F_minus_keep)/(2*dxdot);
        
    end
end

A_P = zeros(n,n);

for i=1:n
    for j=1:n
        dx = DX(i,j);
        
        x_plus = Xo;
        x_minus = Xo;
        
        x_plus(j) = x_plus(j) + dx;
        x_minus(j) = x_minus(j) - dx;
        
        F = feval(MY_FUN,XDOTo,x_plus,Uo);
        F_plus_keep = F(i);
        
        F = feval(MY_FUN,XDOTo,x_minus,Uo);
        F_minus_keep = F(i);
        
        A_P(i,j) = (F_plus_keep - F_minus_keep)/(2*dxdot);
        
    end
end

B_P = zeros(n,n);

for i=1:n
    for j=1:m
        du = DU(i,j);
        
        u_plus = Uo;
        u_minus = Uo;
        
        u_plus(j) = u_plus(j) + du;
        u_minus(j) = u_minus(j) - du;
        
        F = feval(MY_FUN,XDOTo,Xo,u_plus);
        F_plus_keep = F(i);
        
        F = feval(MY_FUN,XDOTo,Xo,u_minus);
        F_minus_keep = F(i);
        
        B_P(i,j) = (F_plus_keep - F_minus_keep)/(2*dxdot);
        
    end
end
        