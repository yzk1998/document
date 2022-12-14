# $\color{red}\text{Optimal Control of Switched System}$ 

## Switched System
$$
\dot{x} = f_{i}(x,u)
$$
switching sequence:
$$
\sigma = ((t_{0},i_{0}),(t_{1},i_{1}),\dots,(t_{K},i_{K}))
$$


## Optimal Control Problem

## ==Problem 1==
Given:
* subsystem $\dot{x}=f_{i}(x,u)$
* a fixed time interval $[t_{0},t_{f}]$
* a prespecified squence of active subsystems $\sigma = ((t_{0},i_{0}),(t_{1},i_{1}),\dots,(t_{K},i_{K}))$
* $x(t_{0})=x_{0}$
* meet $S_{f}$ at $t_{f}$

find a continuous input $u \in U_{[t_{0},t_{f}]}$ and switching instants $t_{1},\dots ,t_{K}$

such that 
* minimize cost function $$
J = \varPsi(x(t_{f})) + \int_{t_{0}}^{t_{f}}L(x(t),u(t))dt
$$
$\varPsi$为终端部分,$L$为积分部分.

## Two Stage Decomposition
Decomposition Problem 1 into two stages.

## Stage(a)

find an optimal continuous input u and the corresponding minimum $J$.

Seek $J_{1}(\hat{t})$ for the corresponding $\hat{t}=(t_{1},\dots,t_{k})^{T}$ is conventional since these intervals are fixed.

Only difference is system dynamics changes with respect to different time intervals.

### ==Theorem 1==Necessary conditions for stage (a)
Assume:
* the subsystem k is active in $[t_{k-1},t_{k})$ ,$k \in [1,K]$.
* subsystem K+1 is active in $[t_{K},t_{K+1}]$,$t_{K+1}=t_{f}$.
* $u \in U_{[t_{0},t_{f}]}$ continuous input such that $x(t_{0}) = x_{0}$ and meets $S_{f} = \{x | \varPhi_{f}(x) = 0,\varPhi : R^{n} \rarr   R^{l_{f}}\}$ at $t_{f}$.
> such that $\Phi_f(x(t_{f})) = 0$

In order for u is optimal :
*   exist a vector function $p(t) = [p_{1}(t),\dots ,p_{n}(t)]^{T},t\in [t_{0},t_{f}]$ .

Such that following conditions:
* $H(x,p,u) = L(x,u) + p^{T}f_{k}(x,u),$ $\text{for any } t\in [t_{0},t_{f}]$
    1. 状态方程state equations: $\frac{dx(t)}{dt} = (\frac{\partial H}{\partial p}(x(t),p(t),u(t)))^{T}$
    2. 协态方程costate equations: $\frac{dp(t)}{dt} = -(\frac{\partial H}{\partial x}(x(t),p(t),u(t)))^{T}$
    3. 控制方程 stationarity condition: $0 = (\frac{\partial H}{\partial u}(x(t),p(t),u(t)))^{T}$
    4. 横截条件 $p(t_{f}) = \frac{\partial \varPsi}{\partial x}(x(t_{f}))^{T} + \frac{\partial \Phi_{f}}{\partial x}(x(t_{f}))^{T} \lambda$
    5. 连续性条件$p(t_{k^{-}}) = p(t_{k^{+}})$.


##Stage(b)
solve the constrained nonlinear optimization problem
$$
    min_{\tilde{t}} J_{1}(\hat{t}) \\ 
    \text{subject to }\hat{t} \in T
$$

Algorithm:  
1. Set the iteration index $j=0$.Choose an initial $\tilde{t}^{j}$.
2. By solving an optimal control problem .
3. Find $\frac{\partial J_{1}}{\partial \hat{t}}(\tilde{t}^{j})$ and $\frac{\partial^{2} J_{1}}{\partial \hat{t}^{2}}(\tilde{t}^{j})$.
4. Use some feasible direction method to update $\tilde{t}^{j} $ to $\tilde{t}^{j+1} $.
5. Repeat step(2),(3),(4),(5).








## ==Problem 2==
Given:
* a switched system $$
\dot{x} = f_{1}(x,u),t_{0} \le t\le t_{1}
$$
$$
\dot{x} = f_{2}(x,u),t_{1} \le t\le t_{f}
$$
* $t_{0}$,$t_{f}$ and $x(t_{0}) = x_{0}$

find a switching instant $t_{1}$ and $u(t)$

such that 
* minimize the cost functional 
$$
J = \varPsi(x(t_{f})) + \int_{t_{0}}^{t_{f}}L(x,u)dt
$$

## ==Problem 3== (an Equivalent Problem)
***introduce*** a state variable $x_{n+1}$ corresponding to $t_{1}$.
$x_{n+1}$ satisfy 
$$
\frac{dx_{n+1}}{dt} = 0
$$
$$
x_{n+1}(0) = t_{1}
$$

这里 $x_{n+1}$ 为一常量 $t_{1}$ ,不过会在下一节中看作未知参数.

***introduce*** a new independent time variable $\tau$.
$t$ will become $\tau$ and $u_{n+1}$
$$
t = \begin{cases}
   t_{0}+(x_{n+1}-t_{0})\tau &\  0 \le \tau \le 1 \\
   x_{n+1}+(t_{f}-x_{n+1})(\tau -1) &\  1 \le \tau \le 2
\end{cases}
$$

显然$t = t_{0},\tau = 0$;$t = t_{1},\tau = 1$;$t = t_{f},\tau = 2$

Given:
* a system 

in the interval $\tau \in [0,1)$ 
$$
\frac{dx(\tau)}{d\tau} = (x_{n+1}-t_{0})f_{1}(x,u)
$$
$$
\frac{dx_{n+1}}{d\tau} = 0
$$

in the interval $\tau \in [1,2]$ 
$$
\frac{dx(\tau)}{d\tau} = (t_{f}-x_{n+1})f_{2}(x,u)
$$
$$
\frac{dx_{n+1}}{d\tau} = 0
$$
* $t_{0}$,$t_{f}$ and $x(0) = x_{0}$

such that:

* minimize the cost functional
$$
J = \varPsi(x(2)) + \int_{0}^{1}(x_{n+1}-t_{0})L(x,u)d\tau + \int_{1}^{2}(t_{f}-x_{n+1})L(x,u)d\tau
$$

Q:引入$\tau$的作用是什么?
1. 切换时刻不再是时变的,整个问题变为传统问题
2. 将$x_{n+1}$看作参数,Problem2 和 Problem3 维数相同


## Method Based on Solving a Boundary Value Differential Algebraic Equation

Define:
* $\tilde{f_{1}}(x,u,x_{n+1}) = (x_{n+1}-t_{0})f_{1}(x,u)$
* $\tilde{f_{2}}(x,u,x_{n+1}) = (t_{f}-x_{n+1})f_{2}(x,u)$
* $\tilde{L_{1}}(x,u,x_{n+1}) = (x_{n+1}-t_{0})L(x,u)$
* $\tilde{L_{2}}(x,u,x_{n+1}) = (t_{f}-x_{n+1})L(x,u)$

Regarding $x_{n+1}$ as a parameter,$x(\tau)\rarr x(\tau,x_{n+1})$.

* Parameterized Hamiltonian $$
H(x,p,u,x_{n+1}) = \begin{cases}
   \tilde{L}_{1}(x,u,x_{n+1})+p^{T}\tilde{f_{1}}(x,u,x_{n+1}) &\  0 \le \tau \le 1 \\
   \tilde{L}_{2}(x,u,x_{n+1})+p^{T}\tilde{f_{2}}(x,u,x_{n+1}) &\  1 \le \tau \le 2
\end{cases}
$$

Assume:
* $x_{n+1}$ is a given fixed unknown parameter

Apply Theorem 1 to Problem 3:
1. 状态方程state equ: $\frac{\partial x}{\partial \tau} = (\frac{\partial H}{\partial p})^{T} = \tilde{f_{k}}(x,u,x_{n+1}) $
2. 协态方程costate function: $\frac{\partial p}{\partial \tau} = -(\frac{\partial H}{\partial x})^{T} = -(\frac{\partial \tilde{f_{k}}}{\partial x})^{T}p - (\frac{\partial \tilde{L_{k}}}{\partial x})^{T} $
3. 控制方程 stationarity equ: $0 = (\frac{\partial H}{\partial u})^{T} = (\frac{\partial \tilde{f_{k}}}{\partial u})^{T}p+(\frac{\partial \tilde{L_{k}}}{\partial u})^{T}$
4. 边界条件 $x(0,x_{n+1}) = x_{0}$ ; $p(2,x_{n+1}) = (\frac{\partial \varPsi}{\partial x}(x(2,x_{n+1})))^{T}$.
5. 连续性条件 $p(1^{-},x_{n+1}) = p(1^{+},x_{n+1})$
6. cost function $$
J(x_{n+1}) = \varPsi(x(2,x_{n+1})) + \int_{0}^{1}\tilde{L}(x,u,x_{n+1})d\tau + \int_{1}^{2}\tilde{L}(x,u,x_{n+1})d\tau
$$

differentiating above function with respect to $x_{n+1}$.$(33)-(39)$


---



## ==Problem 4==General Switched Linear Quadratic Problem 
Given:
* a switched system $$
\dot{x} = A_{1}x + B_{1}u,t_{0} \le t \le t_{1}
$$
$$
\dot{x} = A_{2}x + B_{2}u,t_{1} \le t \le t_{f}
$$

find a switching instant $t_{1}$ and a continous input u

such that:
* minimize cost functional $$
J = \underbrace{\frac{1}{2}x(t_{f})^{T}Q_{f}x(t_{f})+M_{f}x(t_{f})+W_{f})}_{\varPsi} + \int_{t_{0}}^{t_{f}}\underbrace{(\frac{1}{2}x^{T}Qx+x^{T}Vu+\frac{1}{2}u^{T}Ru +Mx +Nu+ W)}_{L(x,u)}dt
$$

## ==Problem 5==Equivalent GSLQ problem
Given:
* a system 

in the interval $\tau \in [0,1)$ 
$$
\frac{dx(\tau)}{d\tau} = (x_{n+1}-t_{0})(A_{1}x+B_{1}u)
$$
$$
\frac{dx_{n+1}}{d\tau} = 0
$$

in the interval $\tau \in [1,2]$ 
$$
\frac{dx(\tau)}{d\tau} = (t_{f}-x_{n+1})(A_{2}x+B_{2}u)
$$
$$
\frac{dx_{n+1}}{d\tau} = 0
$$

find a $x_{n+1}$ and $u_{\tau}$
such that:
* minimize
$$
J = \underbrace{\frac{1}{2}x(2)^{T}Q_{f}x(2)+M_{f}x(2)+W_{f})}_{\varPsi} + \int_{0}^{1}(x_{n+1}-t_{0})L(x,u)d\tau + \int_{1}^{2}(t_{f} - x_{n+1})L(x,u)d\tau
$$

aassume:
* the optimal value function 值函数:$$
V^{*}(x,\tau,x_{n+1}) = \frac{1}{2}x^{T}P(\tau,x_{n+1})x + S(\tau,x_{n+1})x+T(\tau,x_{n+1})
$$
* 计算 ==HJB function==: 
    * HJB计算公式
    $$
    -\frac{\partial V^{\star}}{\partial t}(x,t) = min_{u}\{F+\frac{\partial V^{\star}}{\partial t}f\}
    $$

    * in the interval $\tau \in [0,1]$
$$
-\frac{\partial V^{\star}}{\partial \tau}(x,\tau,x_{n+1}) = min_{u(\tau)}\{(x_{n+1}-t_{0})(L(x,u)+\frac{\partial V^{\star}}{\partial x}(x,\tau,x_{n+1})f_{1}(x,u))\}
$$
    * in the interval $\tau \in [1,2]$
$$
-\frac{\partial V^{\star}}{\partial \tau}(x,\tau,x_{n+1}) = min_{u(\tau)}\{(t_{f}-x_{n+1})(L(x,u)+\frac{\partial V^{\star}}{\partial x}(x,\tau,x_{n+1})f_{2}(x,u))\}
$$

the solution to the above HJB equation:$$
u(x,\tau,x_{n+1}) = R^{-1}(B_{k}^{T}P(\tau,x_{n+1})+V^{T})x(\tau,x_{n+1})-R^{-1}(B_{k}^{T}S^{T}(\tau,x_{n+1})+N^{T})
$$

其中，$P,S,T$满足$(60)-(65)$式和代价函数(66),接着引入参数化方法计算对$x_{n+1}$的微分项$(67)-(73)$.最终再加上$(74)-(79)$的边界条件整体构成一个常微分方程组用 ***Runge-Kutta method*** 求解.

Q.  
什么是HJB function
什么是the optimal value function 
如何解HJB function
P S T V N是什么？




## $ \color{blue} \text{Question}$
1. 引入$x_{n+1}$参数化作用是什么?参数化方法是指什么方法?
2. a two point boundary value DAE 是指$t_{0}$,$t_{f}$给定吗？
3. 引入独立参数$\tau$的作用是什么? 


















