clear;clc

%产生白噪声
noise = 0+randn(1,4000);
realTheta = [1.4;0.45;1;0.7];
y=zeros(2002,1);
u=zeros(2002,1);

y(1) = 100;
y(2) = 100;
u(1) = 1;
u(2) = 1;
y(3) = [-1*y(2);-1*y(1);u(2);u(1)]'*realTheta + noise(3);
u(3) = 0.33*y(3)+0.033*y(2)-0.4*y(1);


y(4) = [-1*y(3);-1*y(2);u(3);u(2)]'*realTheta + noise(4);


u(4) = 0.33*y(4)+0.033*y(3)-0.4*y(2);

n = 3;

k = 0;


theta = zeros(4,2);%theta 初值

alpha = 10000;%alpha为大实数

P = alpha*alpha * eye(4,4);


for k = 2:2000
    Phi = [-1*y(n+k-1);-1*y(n+k-2);u(n+k-1);u(n+k-2)];
    Phi_T = Phi';
    y(n+k) = Phi_T*realTheta + noise(n+k);
    u(n+k) = 0.33*y(n+k)+0.033*y(n+k-1)-0.4*y(n+k-2);
    %u(n+k) = y(n+k)+0.2*y(n+k-1);

end


for k = 2:2000
    Phi = [-1*y(n+k-1);-1*y(n+k-2);u(n+k-1);u(n+k-2)];

    Phi_T = Phi';

    %y(n+k) = Phi_T*realTheta + noise(k);
    % y(n+k) = Phi_T*theta(:,k) + noise(k);


    %反馈控制器
    %非零反馈干扰
    %u(n+k) = 0.33*y(n+k)+0.033*y(n+k-1)-0.4*y(n+k-2);

    theta(:,k+1) = theta(:,k) + ((P*Phi)/(Phi_T*P*Phi+1))*(y(n+k)-Phi_T*theta(:,k));

    P = P - (P*Phi*Phi_T*P)/(Phi_T*P*Phi+1);
end

theta(:,2000)














































