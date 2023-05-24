function [sys,x0,str,ts] = Neutralsystem(t,x,u,flag)

switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1,
    sys=mdlDerivatives(t,x,u);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3,
    sys=mdlOutputs(t,x,u);

    case 2,
        sys=[];
    case 4,
        sys=[];
  case 9,
    sys=[];
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);

end

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=mdlInitializeSizes

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
% Note that in this example, the values are hard coded.  This is not a
% recommended practice as the characteristics of the block are typically
% defined by the S-function parameters.
%
sizes = simsizes;

sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 6;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

x0=[1.8;4.5];

str = [];

ts  = [0 0];


function sys=mdlDerivatives(t,x,u)

A1=[1.8 -0.3;0 2.5];
B1=[-0.8 0;0.5 -0.2];
C1=[-0.2 0.5;0.2 0.7];
D1=[1 0;0 1];
K1=[-4.3178 0.8389;-1.3983 -8.5772];

A2=[0.2 0;0 1.5];
B2=[0.3 0;-0.2 -0.6];
C2=[0.15 0;-0.15 0.8];
D2=[0 0;1 1];
K2=[-3.8051 0.8461;-1.0301 -8.2361];


%%%%%%%%%%%%%%%%%%%%begin：具体定义switching signal%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(t>=0 && t<3)
    signal=2;   %%3
else
    if(t>=3&&t<4)
        signal=1; %1
    else
        if(t>=4&&t<6.5)
            signal=2; %%2.5
        else
            if(t>=6.5&&t<8)
                signal=1;  %1.5
            else
                if(t>=8&&t<10)
                    signal=2;  %%2
                else
                    if(t>=10&&t<12)
                        signal=1;  %2
                    else
                        if(t>=12&&t<13.5)
                            signal=2;  %%1.5
                        else
                            if(t>=13.5&&t<18)
                                signal=1; %4.5
                            else
                                if(t>=18&&t<19)
                                    signal=2; %%1
                                else
                                    if(t>=19&&t<24)
                                        signal=1; %5
                                    else
                                        if(t>=24&&t<26)
                                            signal=2; %%2
                                        else
                                            if(t>=26&&t<30)
                                                signal=1; %4
                                            else
                                                signal=1;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end                      
% % %%%%%%%%%%%%%%%%%%%%end：具体定义switching signal%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%begin:switching signal 决定激活系统子系统%%%%%%%%%%%%
switch signal
    case 1
G1=1;
G2=0;
    case 2
G1=0;
G2=1;

    otherwise
G1=0;
G2=0;
end
% %%%%%%%%%%%end:switching signal 决定激活系统子系统%%%%%%%%%%%%

tau=t-0.3;
%%%%%%%%%%%%%%%%%%%%begin：具体定义switching signal u%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(tau>=-0.3 && tau<3)
    signal_u=2;   %%3
else
    if(tau>=3&&tau<4)
        signal_u=1; %1
    else
        if(tau>=4&&tau<6.5)
            signal_u=2; %%2.5
        else
            if(tau>=6.5&&tau<8)
                signal_u=1;  %1.5
            else
                if(tau>=8&&tau<10)
                    signal_u=2;  %%2
                else
                    if(tau>=10&&tau<12)
                        signal_u=1;  %2
                    else
                        if(tau>=12&&tau<13.5)
                            signal_u=2;  %%1.5
                        else
                            if(tau>=13.5&&tau<18)
                                signal_u=1; %4.5
                            else
                                if(tau>=18&&tau<19)
                                    signal_u=2; %%1
                                else
                                    if(tau>=19&&tau<24)
                                        signal_u=1; %5
                                    else
                                        if(tau>=24&&tau<26)
                                            signal_u=2; %%2
                                        else
                                            if(tau>=26&&tau<30)
                                                signal_u=1; %4
                                            else
                                                signal_u=1;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end                      
% % %%%%%%%%%%%%%%%%%%%%end：具体定义switching signal u%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%begin:switching signal_u 决定激活子系统控制器%%%%%%%%%%%%
switch signal_u
    case 1
Gu1=1;
Gu2=0;        
    case 2
Gu1=0;
Gu2=1;
    otherwise
Gu1=0;
Gu2=0; 
end
% %%%%%%%%%%%end:switching signal_u 决定激活子系统控制器%%%%%%%%%%%%

        
A=G1*A1+G2*A2;
B=G1*B1+G2*B2;
C=G1*C1+G2*C2;
D=G1*D1+G2*D2;

v=Gu1*K1*[x(1);x(2)]+Gu2*K2*[x(1);x(2)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sys=A*x+B*[u(1);u(2)]+C*[u(3);u(4)]+D*v;

% end mdlDerivatives

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)

A1=[1.8 -0.3;0 2.5];
B1=[-0.8 0;0.5 -0.2];
C1=[-0.2 0.5;0.2 0.7];
D1=[1 0;0 1];
K1=[-4.3178 0.8389;-1.3983 -8.5772];

A2=[0.2 0;0 1.5];
B2=[0.3 0;-0.2 -0.6];
C2=[0.15 0;-0.15 0.8];
D2=[0 0;1 1];
K2=[-3.8051 0.8461;-1.0301 -8.2361];

% A1=[2 -0.2;0 2];
% B1=[-0.5 0;0.1 -0.2];
% C1=[0.1 0;0.1 0.3];
% D1=[1 0;0 1];
% K1=[6.9932 -0.0540;0.0795 8.8208];
% 
% A2=[0.35 0;0 2];
% B2=[0.15 0;0.1 -0.2];
% C2=[0.1 0;0.1 0.3];
% D2=[0 0; 0 1];
% K2=[11.9046 0.3600;0.1762 11.4840];

%%%%%%%%%%%%%%%%%%%%begin：具体定义switching signal%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(t>=0 && t<3)
    signal=2;   %%3
else
    if(t>=3&&t<4)
        signal=1; %1
    else
        if(t>=4&&t<6.5)
            signal=2; %%2.5
        else
            if(t>=6.5&&t<8)
                signal=1;  %1.5
            else
                if(t>=8&&t<10)
                    signal=2;  %%2
                else
                    if(t>=10&&t<12)
                        signal=1;  %2
                    else
                        if(t>=12&&t<13.5)
                            signal=2;  %%1.5
                        else
                            if(t>=13.5&&t<18)
                                signal=1; %4.5
                            else
                                if(t>=18&&t<19)
                                    signal=2; %%1
                                else
                                    if(t>=19&&t<24)
                                        signal=1; %5
                                    else
                                        if(t>=24&&t<26)
                                            signal=2; %%2
                                        else
                                            if(t>=26&&t<30)
                                                signal=1; %4
                                            else
                                                signal=1;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end                      
% % %%%%%%%%%%%%%%%%%%%%end：具体定义switching signal%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%begin:switching signal 决定激活系统子系统%%%%%%%%%%%%
switch signal
    case 1
G1=1;
G2=0;
    case 2
G1=0;
G2=1;

    otherwise
G1=0;
G2=0;
end
% %%%%%%%%%%%end:switching signal 决定激活系统子系统%%%%%%%%%%%%

tau=t-0.308;
%%%%%%%%%%%%%%%%%%%%begin：具体定义switching signal u%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(tau>=-0.308 && tau<3)
    signal_u=2;   %%3
else
    if(tau>=3&&tau<4)
        signal_u=1; %1
    else
        if(tau>=4&&tau<6.5)
            signal_u=2; %%2.5
        else
            if(tau>=6.5&&tau<8)
                signal_u=1;  %1.5
            else
                if(tau>=8&&tau<10)
                    signal_u=2;  %%2
                else
                    if(tau>=10&&tau<12)
                        signal_u=1;  %2
                    else
                        if(tau>=12&&tau<13.5)
                            signal_u=2;  %%1.5
                        else
                            if(tau>=13.5&&tau<18)
                                signal_u=1; %4.5
                            else
                                if(tau>=18&&tau<19)
                                    signal_u=2; %%1
                                else
                                    if(tau>=19&&tau<24)
                                        signal_u=1; %5
                                    else
                                        if(tau>=24&&tau<26)
                                            signal_u=2; %%2
                                        else
                                            if(tau>=26&&tau<30)
                                                signal_u=1; %4
                                            else
                                                signal_u=1;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end                      
% % %%%%%%%%%%%%%%%%%%%%end：具体定义switching signal u%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%begin:switching signal_u 决定激活子系统控制器%%%%%%%%%%%%
switch signal_u
    case 1
Gu1=1;
Gu2=0;        
    case 2
Gu1=0;
Gu2=1;
    otherwise
Gu1=0;
Gu2=0; 
end
% %%%%%%%%%%%end:switching signal_u 决定激活子系统控制器%%%%%%%%%%%%

A=G1*A1+G2*A2;
B=G1*B1+G2*B2;
C=G1*C1+G2*C2;
D=G1*D1+G2*D2;

v=Gu1*K1*[x(1);x(2)]+Gu2*K2*[x(1);x(2)];

sys(1)=x(1);
sys(2)=x(2);
sys(3)=v(1);
sys(4)=v(2);
sys(5)=signal;
sys(6)=signal_u;







% end mdlOutputs

