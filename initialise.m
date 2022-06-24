%initialize constants

clear;
clc;
close all;

%% Define Initial Conditions

x0 = [85;
       0
       0
       0
       0
       0
       0
       0
       0];
        
 
u = [0;
    0;
    0
    0.8;
    0.8];

TF = 40;

%% Saturation 

u1min = -25*pi/180;
u1max =  25*pi/180;
u2min = -25*pi/180;
u2max =  10*pi/180;
u3min = -30*pi/180;
u3max =  30*pi/180;
u4min =  0;
u4max =  10*pi/180;
u5min =  0; %0.5*pi/180;
u5max =  10*pi/180;;

%% Run
sim('six_dof_simulation.slx')

%% PLOT
t=simX.Time;
%plot(ScopeData.time, ScopeData.signals.values)

u1 = simU.Data(:,1);
u2 = simU.Data(:,2);
u3 = simU.Data(:,3);
u4 = simU.Data(:,4);
u5 = simU.Data(:,5);

x1 = simX.Data(:,1);
x2 = simX.Data(:,2);
x3 = simX.Data(:,3);
x4 = simX.Data(:,4);
x5 = simX.Data(:,5);
x6 = simX.Data(:,6);
x7 = simX.Data(:,7);
x8 = simX.Data(:,8);
x9 = simX.Data(:,9);

figure
subplot(5,1,1)
plot(t,u1,'b')
legend('u_1')
grid on


subplot(5,1,2)
plot(t,u2,'g*')
legend('u_2')
grid on


subplot(5,1,3)
plot(t,u3,'r*')
legend('u_3')
grid on


subplot(5,1,4)
plot(t,u4,'c*')
legend('u_4')
grid on

subplot(5,1,5)
plot(t,u5,'r*')
legend('u_5')
grid on


%plot states
figure
subplot(3,3,1)
plot(t,x1)
legend('x_1= vel in x')
grid on

subplot(3,3,2)
plot(t,x2)
legend('x_2=  vel in y')
grid on

subplot(3,3,3)
plot(t,x3)
legend('x_3=  vel in z')
grid on

subplot(3,3,4)
plot(t,x4)
legend('x_4= w in x')
grid on

subplot(3,3,5)
plot(t,x5)
legend('x_5= w in y')
grid on


subplot(3,3,6)
plot(t,x6)
legend('x_6= w in z')
grid on


subplot(3,3,7)
plot(t,x7)
legend('x_7= bank angle')
grid on


subplot(3,3,8)
plot(t,x8)
legend('x_8= pitch angle')
grid on


subplot(3,3,9)
plot(t,x9)
legend('x_9= yaw angle')
grid on