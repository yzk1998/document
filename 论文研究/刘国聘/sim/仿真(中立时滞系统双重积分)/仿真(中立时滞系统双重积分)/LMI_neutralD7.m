clc;
%%%%%%%%%%%%%%
A1=[1.8 -0.3;0 2.5];
B1=[-0.8 0;0.5 -0.2];
C1=[-0.2 0.5;0.2 0.7];
D1=[1 0;0 1];

%%%%%%%%%%%%fujun-system
% A1=[-2.5 0.3;0 -1.5];
% B1=[-0.2 0.2;0.1 -0.1];
% C1=[-0.1 0.1;0 0.2];
% D1=[1;1];


A2=[0.2 0;0 1.5];
B2=[0.3 0;-0.2 -0.6];
C2=[0.15 0;-0.15 0.8];
D2=[0 0;1 1];

alpha1=0.5;
alpha2=-1;
beta1=1;
beta2=1;

tau=0.8;
h=0.8;
mu=10;


a_tau1=-alpha1*tau;
a_tau2=0;
a_h1=-alpha1*h;
a_h2=0;
%%%%%%%%%%%%%

%线性矩阵不等式描述以setlmis([])开始
setlmis([]);
%定义P,Q,R,S,M八个需要求解的矩阵
P1=lmivar(1,[2 1]);
Q1=lmivar(1,[2 1]);
R1=lmivar(1,[2 1]);
S1=lmivar(1,[2 1]);
M1=lmivar(1,[2 1]);
W1=lmivar(2,[2 2]);
J1=lmivar(2,[2 2]);

P2=lmivar(1,[2 1]);
Q2=lmivar(1,[2 1]);
R2=lmivar(1,[2 1]);
S2=lmivar(1,[2 1]);
M2=lmivar(1,[2 1]);
W2=lmivar(2,[2 2]);
J2=lmivar(2,[2 2]);

%描述三个不等式,默认不等号方向'<'
lmiterm([1 1 1 P1],alpha1,1);
lmiterm([1 1 1 Q1],1,1);
lmiterm([1 1 1 R1],-1/tau,1);
lmiterm([1 1 1 M1],-1/h,1);
lmiterm([1 1 1 W1],A1,1,'s');
lmiterm([1 1 1 J1],D1,1,'s');
lmiterm([1 1 2 R1],exp(-alpha1*tau/2)/tau,1);
lmiterm([1 1 2 W1],B1,1);
lmiterm([1 1 3 W1],C1,1);
lmiterm([1 1 4 M1],exp(-alpha1*h/2)/h,1);
lmiterm([1 1 5 P1],1,1);
lmiterm([1 1 5 -W1],1,A1');
lmiterm([1 1 5 -J1],1,D1');
lmiterm([1 1 5 W1],-1,1);
lmiterm([1 2 2 Q1],-exp(-alpha1*tau),1);
lmiterm([1 2 2 R1],-exp(-alpha1*tau)/tau,1);
lmiterm([1 2 5 -W1],1,B1');
lmiterm([1 3 3 S1],-exp(-alpha1*h),1);
lmiterm([1 3 5 -W1],1,C1');
lmiterm([1 4 4 M1],-exp(-alpha1*h)/h,1);
lmiterm([1 5 5 R1],tau,1);
lmiterm([1 5 5 S1],1,1);
lmiterm([1 5 5 M1],h,1);
lmiterm([1 5 5 W1],-1,1,'s');

lmiterm([2 1 1 P2],alpha2,1);
lmiterm([2 1 1 Q2],1,1);
lmiterm([2 1 1 R2],-1/tau,1);
lmiterm([2 1 1 M2],-1/h,1);
lmiterm([2 1 1 W2],A2,1,'s');
lmiterm([2 1 1 J2],D2,1,'s');
lmiterm([2 1 2 R2],exp(-alpha2*tau/2)/tau,1);
lmiterm([2 1 2 W2],B2,1);
lmiterm([2 1 3 W2],C2,1);
lmiterm([2 1 4 M2],exp(-alpha2*h/2)/h,1);
lmiterm([2 1 5 P2],1,1);
lmiterm([2 1 5 -W2],1,A2');
lmiterm([2 1 5 -J2],1,D2');
lmiterm([2 1 5 W2],-1,1);
lmiterm([2 2 2 Q2],-exp(-alpha2*tau),1);
lmiterm([2 2 2 R2],-exp(-alpha2*tau)/tau,1);
lmiterm([2 2 5 -W2],1,B2');
lmiterm([2 3 3 S2],-exp(-alpha2*h),1);
lmiterm([2 3 5 -W2],1,C2');
lmiterm([2 4 4 M2],-exp(-alpha2*h)/h,1);
lmiterm([2 5 5 R2],tau,1);
lmiterm([2 5 5 S2],1,1);
lmiterm([2 5 5 M2],h,1);
lmiterm([2 5 5 W2],-1,1,'s');

lmiterm([3 1 1 P1],-beta1,1);
lmiterm([3 1 1 Q1],1,1);
lmiterm([3 1 1 R1],-1/tau,1);
lmiterm([3 1 1 M1],-1/h,1);
lmiterm([3 1 1 R1],-3*(alpha1+beta1)*exp(a_tau1),1);
lmiterm([3 1 1 M1],-3*(alpha1+beta1)*exp(a_h1),1);
lmiterm([3 1 1 W2],A1,1,'s');
lmiterm([3 1 1 J2],D1,1,'s');
lmiterm([3 1 2 R1],exp(-alpha1*tau/2)/tau,1);
lmiterm([3 1 2 W2],B1,1);
lmiterm([3 1 3 W2],C1,1);
lmiterm([3 1 4 M1],exp(-alpha1*h/2)/h,1);
lmiterm([3 1 5 P1],1,1);
lmiterm([3 1 5 -W2],1,A1');
lmiterm([3 1 5 -J2],1,D1');
lmiterm([3 1 5 W2],-1,1);
%lmiterm([3 1 7 R1],6*(alpha1+beta1)*exp(a_tau1)/(tau*tau),1);
%lmiterm([3 1 9 M1],6*(alpha1+beta1)*exp(a_h1)/(h*h),1);
lmiterm([3 2 2 R1],-exp(-alpha1*tau)/tau,1);
lmiterm([3 2 2 Q1],-exp(-alpha1*tau),1);
lmiterm([3 2 5 -W2],1,B1');
lmiterm([3 3 3 S1],-exp(-alpha1*h),1);
lmiterm([3 3 5 -W2],1,C1');
lmiterm([3 4 4 M1],-exp(-alpha1*h)/h,1);
lmiterm([3 5 5 R1],tau,1);
lmiterm([3 5 5 S1],1,1);
lmiterm([3 5 5 M1],h,1);
lmiterm([3 5 5 W2],-1,1,'s');
%lmiterm([3 6 6 R1],-6*(alpha1+beta1)*exp(a_tau1)/(tau*tau),1);
lmiterm([3 6 6 Q1],-(alpha1+beta1)*exp(a_tau1)/tau,1);
%lmiterm([3 6 7 R1],12*(alpha1+beta1)*exp(a_tau1)/(tau*tau*tau),1);
%lmiterm([3 7 7 R1],-36*(alpha1+beta1)*exp(a_tau1)/(tau*tau*tau*tau),1);
%lmiterm([3 8 8 M1],-6*(alpha1+beta1)*exp(a_h1)/(h*h),1);
lmiterm([3 7 7 S1],-(alpha1+beta1)*exp(a_h1)/h,1);
%lmiterm([3 8 9 M1],12*(alpha1+beta1)*exp(a_h1)/(h*h*h),1);
%lmiterm([3 9 9 M1],-36*(alpha1+beta1)*exp(a_h1)/(h*h*h*h),1);


lmiterm([4 1 1 P2],-beta2,1);
lmiterm([4 1 1 Q2],1,1);
lmiterm([4 1 1 R2],-1/tau,1);
lmiterm([4 1 1 M2],-1/h,1);
lmiterm([4 1 1 R2],-3*(alpha2+beta2)*exp(a_tau2),1);
lmiterm([4 1 1 M2],-3*(alpha2+beta2)*exp(a_h2),1);
lmiterm([4 1 1 W1],A2,1,'s');
lmiterm([4 1 1 J1],D2,1,'s');
lmiterm([4 1 2 R2],exp(-alpha2*tau/2)/tau,1);
lmiterm([4 1 2 W1],B2,1);
lmiterm([4 1 3 W1],C2,1);
lmiterm([4 1 4 M2],exp(-alpha2*h/2)/h,1);
lmiterm([4 1 5 P2],1,1);
lmiterm([4 1 5 -W1],1,A2');
lmiterm([4 1 5 -J1],1,D2');
lmiterm([4 1 5 W1],-1,1);
%lmiterm([4 1 7 R2],6*(alpha2+beta2)*exp(a_tau2)/(tau*tau),1);
%lmiterm([4 1 9 M2],6*(alpha2+beta2)*exp(a_h2)/(h*h),1);
lmiterm([4 2 2 R2],-exp(-alpha2*tau)/tau,1);
lmiterm([4 2 2 Q2],-exp(-alpha2*tau),1);
lmiterm([4 2 5 -W1],1,B2');
lmiterm([4 3 3 S2],-exp(-alpha2*h),1);
lmiterm([4 3 5 -W1],1,C2');
lmiterm([4 4 4 M2],-exp(-alpha2*h)/h,1);
lmiterm([4 5 5 R2],tau,1);
lmiterm([4 5 5 S2],1,1);
lmiterm([4 5 5 M2],h,1);
lmiterm([4 5 5 W1],-1,1,'s');
%lmiterm([4 6 6 R2],-6*(alpha2+beta2)*exp(a_tau2)/(tau*tau),1);
lmiterm([3 6 6 Q2],-(alpha2+beta2)*exp(a_tau2)/tau,1);
%lmiterm([4 6 7 R2],12*(alpha2+beta2)*exp(a_tau2)/(tau*tau*tau),1);
%lmiterm([4 7 7 R2],-36*(alpha2+beta2)*exp(a_tau2)/(tau*tau*tau*tau),1);
%lmiterm([4 8 8 M2],-6*(alpha2+beta2)*exp(a_h2)/(h*h),1);
lmiterm([4 7 7 S2],-(alpha2+beta2)*exp(a_h2)/h,1);
%lmiterm([4 8 9 M2],12*(alpha2+beta2)*exp(a_h2)/(h*h*h),1);
%lmiterm([4 9 9 M2],-36*(alpha2+beta2)*exp(a_h2)/(h*h*h*h),1);

lmiterm([-5 1 1 P1],1,1);
lmiterm([-6 1 1 Q1],1,1);
lmiterm([-7 1 1 R1],1,1);
lmiterm([-8 1 1 S1],1,1);
lmiterm([-9 1 1 M1],1,1);
lmiterm([-10 1 1 W1],1,1);

lmiterm([-11 1 1 P2],1,1);
lmiterm([-12 1 1 Q2],1,1);
lmiterm([-13 1 1 R2],1,1);
lmiterm([-14 1 1 S2],1,1);
lmiterm([-15 1 1 M2],1,1);
lmiterm([-16 1 1 W2],1,1);

lmiterm([17 1 1 P1],1,1);
lmiterm([-17 1 1 P2],mu,1);
lmiterm([18 1 1 P2],1,1);
lmiterm([-18 1 1 P1],mu,1);

lmiterm([19 1 1 Q1],1,1);
lmiterm([-19 1 1 Q2],mu,1);
lmiterm([20 1 1 Q2],1,1);
lmiterm([-20 1 1 Q1],mu*exp((alpha2-alpha1)*tau),1);

lmiterm([21 1 1 R1],1,1);
lmiterm([-21 1 1 R2],mu,1);
lmiterm([22 1 1 R2],1,1);
lmiterm([-22 1 1 R1],mu*exp((alpha2-alpha1)*tau),1);

lmiterm([23 1 1 S1],1,1);
lmiterm([-23 1 1 S2],mu,1);
lmiterm([24 1 1 S2],1,1);
lmiterm([-24 1 1 S1],mu*exp((alpha2-alpha1)*h),1);

lmiterm([25 1 1 M1],1,1);
lmiterm([-25 1 1 M2],mu,1);
lmiterm([26 1 1 M2],1,1);
lmiterm([-26 1 1 M1],mu*exp((alpha2-alpha1)*h),1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%线性矩阵不等式描述以lmis=getlmis结束
lmis=getlmis;
[tmin,xfeas]=feasp(lmis);

P1=dec2mat(lmis,xfeas,P1);
Q1=dec2mat(lmis,xfeas,Q1);
R1=dec2mat(lmis,xfeas,R1);
S1=dec2mat(lmis,xfeas,S1);
M1=dec2mat(lmis,xfeas,M1);
W1=dec2mat(lmis,xfeas,W1);

P2=dec2mat(lmis,xfeas,P2);
Q2=dec2mat(lmis,xfeas,Q2);
R2=dec2mat(lmis,xfeas,R2);
S2=dec2mat(lmis,xfeas,S2);
M2=dec2mat(lmis,xfeas,M2);
W2=dec2mat(lmis,xfeas,W2);

k1=J1*inv(W1);
k2=J2*inv(W2);

%alpha1=dec2mat(lmis,xfeas,alpha1)
% beta2=dec2mat(lmis,xfeas,beta2)
% k2=M2*inv(P2)


% eig_s1=eig(S1)
% eig_s2=eig(S2)
% 
% P1=inv(S1)
% %eig_p1=eig(P1)
% 
% P2=inv(S2)
%eig_p2=eig(P2)
%eig_mu=eig(-2.5*S1+S2)

tmin