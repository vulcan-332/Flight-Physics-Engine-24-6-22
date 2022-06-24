function XDOT  = RCAM_plant(X,U)

//--------STATE INDEXING--------//

x1=X(1); // u A/C velocity in X
x2=X(2); // v A/C velocity in Y
x3=X(3); // w A/C velocity in Z
x4=X(4); // p A/C angular velocity in X
x5=X(5); // q A/C angular velocity in Y
x6=X(6); // r A/C angular velocity in Z
x7=X(7); // phi Roll Euler Angle
x8=X(8); // theta Pitch Euler Angle 
x9=X(9); // psi Yaw Euler Angle

//--------CONTROL INDEXING-------//
                                 //LIMITS * (pi/180)
u1=U(1); // Aileron deflection   [-25deg 25deg]
u2=U(2); // Elevator deflection  [-25deg 10deg]
u3=U(3); // Rudder deflection    [-30deg 30deg]
u4=U(4); // Throttle 1                [0.5  10]
u5=U(5); // Throttle 2                [0.5  10]

//--------CONTROL LIMITS----------//

u1min = -25*pi/180;
u1max =  25*pi/180;
u2min = -25*pi/180;
u2max =  10*pi/180;
u3min = -30*pi/180;
u3max =  30*pi/180;
u4min =  0.5*pi/180;
u4max =  10*pi/180;
u5min =  0.5*pi/180;
u5max =  10*pi/180;

// if(u1>u1max)
//     u1=u1max;
// elseif(u1<u1min)
//     u1=u1min;
// end
// 
// if(u2>u2max)
//     u2=u2max;
// elseif(u2<u2min)
//     u2=u2min;
// end
// 
// if(u3>u3max)
//     u3=u3max;
// elseif(u3<u3min)
//     u3=u3min;
// end
// 
// if(u4>u4max)
//     u4=u4max;
// elseif(u4<u4min)
//     u4=u4min;
// end
// 
// if(u5>u5max)
//     u5=u5max;
// elseif(u5<u5min)
//     u5=u5min;
// end


//-----------CONSTANTS--------//
//aircraft constants
m=120000; // Aircraft Mass (kgs)
cbar=6.6; // Mean Aerodynamic chord (m)
lt=24.8;  // Distance of aerocentre (m)
S=260;    // Wing planform Area (m^2)
St=64;    // Tail planform Area (m^2)

Xcg=0.23*cbar; //x position of Cog (m)
Ycg=0;         //y position of Cog (m)
Zcg=0.10*cbar;  //z position of Cog (m)

Xac=0.12*cbar; //x position of aerocentre (m)
Yac=0;         //y position of aerocentre (m)
Zac=0;         //z position of aerocentre (m)


//engine number 1 constants
Xapt1=0;       //x position of engine (m)
Yapt1= -7.94;  //y position of engine (m)
Zapt1=-1.9;    //z position of engine (m)

//engine number 2 constants
Xapt2=0;       //x position of engine (m)
Yapt2= 7.94;   //y position of engine (m)
Zapt2=-1.9;    //z position of engine (m)

//-----------other constants-------------//
rho= 1.225;    // Density
g=9.81;
depsda = 0.25; //change in downwash
alpha_L0 = -11.5*(pi/180);
n=5.5;
a3 = -768.5;
a2 = 609.2;
a1 = -155.2;
a0 = 15.212;
alpha_switch= 14.5*(pi/180);
alpha_cric=18*(pi/180);
Va=sqrt(x1^2 + x2^2 +x3^2);
alpha=atan2(x3,x1);
beta=asin(x2/Va);
Q=0.5*rho*Va^2;
wbe_b=[x4; x5; x6];
V_b=[x1; x2; x3];




////////---------PLANT------------//////

//--------AERODYNAMIC FORCE CO-EFFICIENTS-------//
//calculating CL_wb --> wing and body
if alpha<alpha_switch
    CL_wb=n*(alpha-alpha_L0);                          // Linear
else 
    CL_wb=a3*alpha^3 +a2*alpha^2 +a1*alpha + a0;  //Cubic
end 

//calcluating CL_t --> tail
epsilon = depsda*(alpha-alpha_L0);
alpha_t = alpha - epsilon + u2 + 1.3*x5*lt/Va;
CL_t = 3.1*(St/S)*alpha_t;

//total CL
CL= CL_t + CL_wb;

//calculating the drag
CD= 0.13 + 0.07*(5.5*alpha + 0.654)^2;

//calculating sideforce
CY = -1.6*beta + 0.24*u3;

//calculate forces
FA_s = [-CD*Q*S;... //stability frame
        CY*Q*S;...
       -CL*Q*S];

//transform force FA from stability frame to body frame     
//C_bs is the transformation matrix
C_bs = [cos(alpha) 0 -sin(alpha);...
        0          1       0;...
        sin(alpha) 0  cos(alpha)];
    
FA_b = C_bs*FA_s;


//------------AERODYNAMIC MOMENTS COEFFICIENTS-------//
eta11 = -1.4*beta;
eta21 = -0.59 - (3.1*(St*lt)/(S*cbar))*(alpha-epsilon);
eta31 = (1-alpha*(180/(15*pi)))*beta;

eta = [eta11;...
       eta21;...
       eta31];
   
dCMdx = (cbar/Va) *  [-11          0                    5;...
                    0   (-4.303*(St*lt^2)/(S*cbar))  0;...
                    1.7           0                  -11.5];

dCMdu = [-0.6           0                0.22;...
          0    (-3.1*(St*lt)/(S*cbar))  0;...
          0         0                     -0.63];

CMac_b = eta + dCMdx*wbe_b +dCMdu*[u1; u2; u3];

//-------------AERODYNAMIC MOMENT ABOUT AEROFYNAMIC CENTRE-----------//
MAac_b = CMac_b*Q*S*cbar;

//-------------AERODYNAMIC MOMENT ABOUT CENTRE OF GRAVITY-----------//
rcg_b = [Xcg; Ycg; Zcg];
rac_b = [Xac; Yac; Zac];

MAcg_b = MAac_b + cross(FA_b, rcg_b-rac_b);



//----------------ENGINE FORCES----------//
F1 = u4*m*g;
F2 = u5*m*g;

FE1_b = [F1; 0; 0];
FE2_b = [F2; 0; 0];

FE_b = FE1_b + FE2_b;

//--------------ENGINE MOMENTS-----------//
mew1_b = [Xcg-Xapt1;
          Yapt1-Ycg;
          Zcg-Zapt1];
      
mew2_b = [Xcg-Xapt2;
          Yapt2-Ycg;
          Zcg-Zapt2];

MEcg1_b = cross(mew1_b,FE1_b);
MEcg2_b = cross(mew2_b,FE2_b);

MEcg_b = MEcg1_b + MEcg2_b;

//-------------GRAVITY EFFECTS-----------//
//Calculate gravitational forces in the body frame.
//Gravity acts at CoG, hence no moment.

g_b = [-g*sin(x8);
            g*cos(x8)*sin(x7);
            g*cos(x8)*cos(x7)];
        
Fg_b = m*g_b;

        
//------------STATE VARIABLES-----------//
Ib = m*[40.07 0  -2.0923;...
        0     64    0;
      -2.0923  0  99.92];

invIb = (1/m)*[0.0249836    0     0.000523151;
                0        0.015625 0;...
                0.000523151 0     0.010019];
      
F_b = Fg_b + FE_b + FA_b;
x1dottox3dot = (1/m)*F_b - cross(wbe_b, V_b);

Mcg_b = MEcg_b +MAcg_b;
x4dottox6dot = invIb*(Mcg_b - cross(wbe_b,Ib*wbe_b));

H_phi = [1 sin(x7)*tan(x8) cos(x7)*tan(x8);
         0  cos(x7)        -sin(x7);
         0   sin(x7)/cos(x8) cos(x7)/cos(x8)];
   
x7dottox9dot = H_phi*wbe_b;

// //navigation
// C1v = [cos(x9) sin(x9) 0;
//     -sin(x9) cos(x9) 0;
//     0 0 1];
// 
// C21 = [cos(x8) 0 -sin(x8);
//     0 1 0;
// sin(x8) 0 cos(x8)];
// 
// Cb2 = [1 0 0;
//     0 cos(x7) sin(x7);
//     0 -sin(x7) cos(x7)];
// 
// Cbv = Cb2*C21*C1v;
// Cvb = Cbv';
// 
// x10dottox12dot = Cvb*V_b;

XDOT = [x1dottox3dot;...
        x4dottox6dot;...
        x7dottox9dot];
