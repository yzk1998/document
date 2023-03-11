clc;clear;

O=[];
J=[];
AIC=[];
F=[];
n=1;%初始阶次
Forder=0;%估计阶次
Fvalue=0;
AICorder=0;
AICvalue=0;
N=1000;

F_signal=0;AIC_signal=0;

y=[0.1;0.2]; 
u=[];u=[u;randn];u=[u;randn]; 
for k=3:N
    y_temp = 1.5*y(k-1)-0.7*y(k-2)+u(k-1)+0.5*u(k-2)+randn;
    u=[u;randn];
    y=[y;y_temp];
end

while true
    Q=[];
    for s=n:N
        vector_temp=[];
        for i=s:-1:(s-n+1)
            vector_temp=[vector_temp,-y(i)];
        end
        for i=s:-1:(s-n+1)
            vector_temp=[vector_temp,u(i)];
        end
        Q=[Q;vector_temp];
    end
    O_hat = (Q'*Q)^-1*Q'*y(n:N); 
    J_temp = (y(n:N)-Q*O_hat)'*(y(n:N)-Q*O_hat);
    O=[[O,zeros(n,2)];O_hat'];
    J=[J;J_temp];

    AIC=(1+2*n/N)*J_temp; %AIC检验值计算
    AIC=[AIC;AIC];
    fprintf(" n: %d,AIC:%f",n,AIC);

    if n>1
         F = (J(end-1)-J(end))/J(end)*(N-2*n^2)/2; 
         F=[F;F];
         fprintf(" F：%f",F);
    end

    %阶次判断
    if n>2&&F(end)<3.083  %F<Fa
        Forder=n-1;
        Fvalue = F(end);
        F_signal=1;
    end
    if n>3&&(AIC(n-2)>AIC(n-1)&&AIC(n-1)<AIC(n))
        AICorder=n-1;
        AICvalue = AIC(n-1);
        AIC_signal=1;
    end

    if F_signal&&AIC_signal
        fprintf("\r\nF检验：%f,阶次%d",Fvalue,Forder);
        fprintf("\r\nAIC检验：%f,阶次为%d",AICvalue,AICorder);
        break;
    end
    fprintf("\r\n");
    n=n+1;%阶次增长
end




