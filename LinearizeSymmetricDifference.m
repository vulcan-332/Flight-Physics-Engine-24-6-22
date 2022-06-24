clear;
clc;
close all;

Xdoto= [
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0];

Xo = [84.9905;
    0;
    1.2713;
    0;
    0;
    0;
    0;
    0.0150;
    0];

Uo = [0;
    -0.1780;
    0;
    0.0821;
    0.0821];

dxdot_matrix = 10e-12*ones(9,9);
dx_matrix = 10e-12*ones(9,9);
du_matrix = 10e-12*ones(9,5);

[E, A_P, B_P] = ImplicitLinmod(@RCAM_model_implicit, Xdoto, Xo, Uo, dxdot_matrix, dx_matrix, du_matrix);

A= -inv(E)*A_P;
B= -inv(E)*B_P;

A
B
E