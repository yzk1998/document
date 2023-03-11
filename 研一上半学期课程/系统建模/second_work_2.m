%%
%一次完成最小二乘估计  F检验  AIC准则
%数据生成,有非零反馈干扰
clc;clear;
O_hat_all=[];
J_all=[];
AIC_all=[];
F_all=[];
n=1;%初始阶次
order_F=0;%估计阶次
F_value=0;
order_AIC=0;
AIC_value=0;
N=1000;%输入输出的数据个数

F_signal=0;AIC_signal=0;

%产生一组白噪声信号作为输入u （0,1）,对应产生y
y=[0.1;0.2]; %初值,尽量不要全为0，否则秩为0矩阵不可逆
u=[];u=[u;randn];u=[u;randn]; %首先迭代两次
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
    O_hat = (Q'*Q)^-1*Q'*y(n:N); %参数估计
    J_temp = (y(n:N)-Q*O_hat)'*(y(n:N)-Q*O_hat);%当前阶次的最小二成指标
    O_hat_all=[[O_hat_all,zeros(n,2)];O_hat'];
    J_all=[J_all;J_temp];

    AIC=(1+2*n/N)*J_temp; %AIC检验值计算
    AIC_all=[AIC_all;AIC];
    fprintf(" n: %d,AIC:%f",n,AIC);

    if n>1
         F = (J_all(end-1)-J_all(end))/J_all(end)*(N-2*n^2)/2; %F检验值计算
         F_all=[F_all;F];
         fprintf(" F：%f",F);
    end

    %阶次判断
    if n>2&&F_all(end)<3.083  %F<Fa
        order_F=n-1;
        F_value = F_all(end);
        F_signal=1;
    end
    if n>3&&(AIC_all(n-2)>AIC_all(n-1)&&AIC_all(n-1)<AIC_all(n))
        order_AIC=n-1;
        AIC_value = AIC_all(n-1);
        AIC_signal=1;
    end

    if F_signal&&AIC_signal
        fprintf("\r\nF检验值：%f,阶次%d",F_value,order_F);
        fprintf("\r\nAIC检验值：%f,阶次%d",AIC_value,order_AIC);
        break;
    end
    fprintf("\r\n");
    n=n+1;%阶次增长
end
fprintf("\r\n");




