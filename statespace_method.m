A = [-0.313 56.7 0; -0.0139 -0.426 0; 0 56.7 0];
B = [0.232; 0.0203; 0];
C = [0 0 1];
D = [0];

co = ctrb(A,B)
co_rank = rank(co)

p=35
Q=p*C'*C
R=1;
K=lqr(A,B,Q,R)

sys_cl=ss(A-B*K,B,C,D);
step(0.2*sys_cl)
axis([0,10,0,0.04])
