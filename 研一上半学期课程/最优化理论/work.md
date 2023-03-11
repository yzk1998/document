# &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;最优化理论结课报告

我将介绍一种基于参数化方法的最优化理论在切换系统中的应用。

## 背景意义

&emsp;&emsp;经典控制理论按照输入信号和输出信号的时间特性将自动控制系统划分为连续时间控制系统和离散时间控制系统。然而，随着科技进步，现代工程控制系统日益复杂，很多实际复杂系统的动态行为同时包含连续时间系统动力学行为和离散时间系统动力学行为，例如电压电流根据基尔霍夫定律连续变化的电子电路受到切换开关影响发生离散化行为，构成切换电子电路系统。这种同时具有连续和离散动态特性的动力特性的动力系统成为混杂动力系统。

&emsp;&emsp;除了上述提到的切换电子电路系统外，混杂动力系统广泛分布于现实中各类工程应用系统中，如存在碰撞行为的机械物理运动系统，多齿轮转换的齿轮传动系统，网络传输控制系统，混合动力汽车等。状态传输时延，外部扰动等等，都将对混杂动态产生不同于单纯离散时间系统或连续时间系统的影响，因此针对混杂系统的分析与设计通常比单纯的离散动态或单纯的连续动态更加困难。由于混杂动态系统的广泛应用及分析综合方面存在较多挑战，近几十年来针对混杂系统的研究越来越受到人们的关注。

&emsp;&emsp;在众多的混杂动态系统中，有一类特殊的系统更加受到国内外研究学者的关注：切换系统。切换系统由有限连续或离散的子系统以及按照某一规则选择特定子系统处于激活工作状态的切换信号或切换律组成。在任意的时间区间内，有且仅有一个子系统处于激活工作状态，这些子系统通常描述成为微分或差分方程形式。在切换系统中，离散的“跳跃”靠切换信号（切换律）实现，由于切换信号的作用是激活某一特定的子系统，因而一般情况下，切换信号是分段连续的常数映射。

&emsp;&emsp;目前，针对切换系统的分类，通常所依据的是其子系统的类别特性，如连续切换系统或离散切换系统，线性切换系统或非线性切换系统等。

&emsp;&emsp;作为一类重要的混杂动态系统，切换系统控制在理论和实际系统中的应用极其广泛，例如手动驾驶汽车换挡调速系统，网络拓扑切换下多智能体系统，机器人控制系统等。

## 工程问题的建模
切换系统基本研究问题一个连续时间切换系统可以描述为如下模型：
$$
\dot{x} = f_{i}(x,u)
$$
切换序列可表示为:
$$
\sigma = ((t_{0},i_{0}),(t_{1},i_{1}),\dots,(t_{K},i_{K}))
$$
&emsp;&emsp;其中,$x(t)∈R^m$分别为系统的状态和控制输入，$σ(t):[0,+∞)→P=\{1,…,p\}$是分段右连续切换信号.在各类理论分析与工程应用系统中，一般来讲，切换规则通常分为基于时间切换，基于状态切换或基于记忆切换(基于曾经激活的模态)三类。$f_i (x(t),u(t)):R^n→R^n$ 为光滑向量函数,$i=σ(t)$其中表示在t时刻运行的子系统，或称在t时刻激活的模态，即若则表示系统状态轨迹将沿着模态的动态方程运动。

&emsp;&emsp;系统稳定性是系统控制与设计的基本问题。如何保证各系统存在切换条件下整个切换系统的稳定性仍是当前针对切换系统研究的重点。然而，切换信号的存在，使得切换系统稳定性分析与设计更加复杂。这体现在对于子系统全都稳定的切换系统，在任意切换下闭环系统状态可能发散变得不稳定。因此在切换的过程中可能会产生一定的由于切换而产生的能量被系统吸收，如果切换的过于频繁，则有可能造成系统吸收能量过多从而无法维持稳定。另外，若系统中含有不稳定的子系统，则在系统切换过于频繁或该不稳定子系统驻留时间过长，整个系统也会变得不稳定。

## 切换系统最优控制问题的建立

### 问题一
已知:
* 子系统模型 $\dot{x}=f_{i}(x,u)$
* 一端固定的时间区间 $[t_{0},t_{f}]$
* 一段已经指定好的切换序列 $\sigma = ((t_{0},i_{0}),(t_{1},i_{1}),\dots,(t_{K},i_{K}))$
* $x(t_{0})=x_{0}$
* 在 $t_{f}$满足$S_{f}$

我们需要找到一个连续输入$u \in U_{[t_{0},t_{f}]}$ 和切换时刻 $t_{1},\dots ,t_{K}$

来满足 
* 对代价函数的取最小值 $$
J = \varPsi(x(t_{f})) + \int_{t_{0}}^{t_{f}}L(x(t),u(t))dt
$$
$\varPsi$为终端部分,$L$为积分部分.

## 问题拆分
将问题一拆分为两部分

### 第一部分

&emsp;&emsp;找到一个最优的连续输入$u$和对应的最小的$J$。

&emsp;&emsp;因为时间区间是固定的，所以找到 $J_{1}(\hat{t})$  对应的 $\hat{t}=(t_{1},\dots,t_{k})^{T}$ 是很容易的。唯一的区别是系统符合的动力学模型随着不同时间区间的变换跟着变换了。

#### 定理一 问题第一部分的一个必要条件
假设:
* 子系统k在区间$[t_{k-1},t_{k})$ ,$k \in [1,K]$上被激活.
* 子系统 K+1 在区间 $[t_{K},t_{K+1}]$,$t_{K+1}=t_{f}上被激活$.
* $u \in U_{[t_{0},t_{f}]}$ 连续输入满足 $x(t_{0}) = x_{0}$ 并且满足 $S_{f} = \{x | \varPhi_{f}(x) = 0,\varPhi : R^{n} \rarr   R^{l_{f}}\}$ at $t_{f}$.
> 即满足 $\Phi_f(x(t_{f})) = 0$

为保证u是最优的需要有:
*   存在一个向量函数$p(t) = [p_{1}(t),\dots ,p_{n}(t)]^{T},t\in [t_{0},t_{f}]$ .

满足以下条件:
* $H(x,p,u) = L(x,u) + p^{T}f_{k}(x,u),$ $\text{for any } t\in [t_{0},t_{f}]$
    1. 状态方程state equations: $\frac{dx(t)}{dt} = (\frac{\partial H}{\partial p}(x(t),p(t),u(t)))^{T}$
    2. 协态方程costate equations: $\frac{dp(t)}{dt} = -(\frac{\partial H}{\partial x}(x(t),p(t),u(t)))^{T}$
    3. 控制方程 stationarity condition: $0 = (\frac{\partial H}{\partial u}(x(t),p(t),u(t)))^{T}$
    4. 横截条件 $p(t_{f}) = \frac{\partial \varPsi}{\partial x}(x(t_{f}))^{T} + \frac{\partial \Phi_{f}}{\partial x}(x(t_{f}))^{T} \lambda$
    5. 连续性条件$p(t_{k^{-}}) = p(t_{k^{+}})$.

###第二部分
解决这个受限的非线性最优化问题
$$
    min_{\tilde{t}} J_{1}(\hat{t}) \\ 
    \text{subject to }\hat{t} \in T
$$

算法如下:  
1. 设置iteration index $j=0$.选择一个初始值 $\tilde{t}^{j}$.
2. 解这个最优控制问题 .
3. 找到 $\frac{\partial J_{1}}{\partial \hat{t}}(\tilde{t}^{j})$ 和 $\frac{\partial^{2} J_{1}}{\partial \hat{t}^{2}}(\tilde{t}^{j})$.
4. 用一些合理的方向来更新 $\tilde{t}^{j} $ to $\tilde{t}^{j+1} $.
5. 重复步骤(2),(3),(4),(5).

## 问题二
已知:
* 一个切换系统 $$
\dot{x} = f_{1}(x,u),t_{0} \le t\le t_{1}
$$
$$
\dot{x} = f_{2}(x,u),t_{1} \le t\le t_{f}
$$
* $t_{0}$,$t_{f}$ and $x(t_{0}) = x_{0}$

找到一个切换时刻 $t_{1}$ and $u(t)$

满足 
* 代价函数最小 
$$
J = \varPsi(x(t_{f})) + \int_{t_{0}}^{t_{f}}L(x,u)dt
$$

## 问题三 (一个等价问题)
***引入*** 一个状态变量 $x_{n+1}$ 对应着 $t_{1}$.
$x_{n+1}$ 满足
$$
\frac{dx_{n+1}}{dt} = 0
$$
$$
x_{n+1}(0) = t_{1}
$$

这里 $x_{n+1}$ 为一常量 $t_{1}$ ,不过会在下一节中看作未知参数.

***引入*** 一个新的独立的时间变量 $\tau$.
$t$ 将会变为 $\tau$ 和 $u_{n+1}$
$$
t = \begin{cases}
   t_{0}+(x_{n+1}-t_{0})\tau &\  0 \le \tau \le 1 \\
   x_{n+1}+(t_{f}-x_{n+1})(\tau -1) &\  1 \le \tau \le 2
\end{cases}
$$

显然$t = t_{0},\tau = 0$;$t = t_{1},\tau = 1$;$t = t_{f},\tau = 2$

已知:
* 一个系统 

在区间 $\tau \in [0,1)$ 
$$
\frac{dx(\tau)}{d\tau} = (x_{n+1}-t_{0})f_{1}(x,u)
$$
$$
\frac{dx_{n+1}}{d\tau} = 0
$$

在区间 $\tau \in [1,2]$ 
$$
\frac{dx(\tau)}{d\tau} = (t_{f}-x_{n+1})f_{2}(x,u)
$$
$$
\frac{dx_{n+1}}{d\tau} = 0
$$
* $t_{0}$,$t_{f}$ and $x(0) = x_{0}$

满足:

* 最小化代价函数
$$
J = \varPsi(x(2)) + \int_{0}^{1}(x_{n+1}-t_{0})L(x,u)d\tau + \int_{1}^{2}(t_{f}-x_{n+1})L(x,u)d\tau
$$

## 一种基于解边界值代数微分方程的方法
定义:
* $\tilde{f_{1}}(x,u,x_{n+1}) = (x_{n+1}-t_{0})f_{1}(x,u)$
* $\tilde{f_{2}}(x,u,x_{n+1}) = (t_{f}-x_{n+1})f_{2}(x,u)$
* $\tilde{L_{1}}(x,u,x_{n+1}) = (x_{n+1}-t_{0})L(x,u)$
* $\tilde{L_{2}}(x,u,x_{n+1}) = (t_{f}-x_{n+1})L(x,u)$

认为 $x_{n+1}$ 是参数,$x(\tau)\rarr x(\tau,x_{n+1})$.

* 将哈密顿方程参数化 $$
H(x,p,u,x_{n+1}) = \begin{cases}
   \tilde{L}_{1}(x,u,x_{n+1})+p^{T}\tilde{f_{1}}(x,u,x_{n+1}) &\  0 \le \tau \le 1 \\
   \tilde{L}_{2}(x,u,x_{n+1})+p^{T}\tilde{f_{2}}(x,u,x_{n+1}) &\  1 \le \tau \le 2
\end{cases}
$$

假设:
* $x_{n+1}$ 是一个给定的固定未知参数

应用定理一到问题三:
1. 状态方程state equ: $\frac{\partial x}{\partial \tau} = (\frac{\partial H}{\partial p})^{T} = \tilde{f_{k}}(x,u,x_{n+1}) $
2. 协态方程costate function: $\frac{\partial p}{\partial \tau} = -(\frac{\partial H}{\partial x})^{T} = -(\frac{\partial \tilde{f_{k}}}{\partial x})^{T}p - (\frac{\partial \tilde{L_{k}}}{\partial x})^{T} $
3. 控制方程 stationarity equ: $0 = (\frac{\partial H}{\partial u})^{T} = (\frac{\partial \tilde{f_{k}}}{\partial u})^{T}p+(\frac{\partial \tilde{L_{k}}}{\partial u})^{T}$
4. 边界条件 $x(0,x_{n+1}) = x_{0}$ ; $p(2,x_{n+1}) = (\frac{\partial \varPsi}{\partial x}(x(2,x_{n+1})))^{T}$.
5. 连续性条件 $p(1^{-},x_{n+1}) = p(1^{+},x_{n+1})$
6. 代价函数 $$
J(x_{n+1}) = \varPsi(x(2,x_{n+1})) + \int_{0}^{1}\tilde{L}(x,u,x_{n+1})d\tau + \int_{1}^{2}\tilde{L}(x,u,x_{n+1})d\tau
$$

将以上方程对 $x_{n+1}$微分.

## 问题四 (General Switched Linear Quadratic问题)
已知:
* 一个切换系统 $$
\dot{x} = A_{1}x + B_{1}u,t_{0} \le t \le t_{1}
$$
$$
\dot{x} = A_{2}x + B_{2}u,t_{1} \le t \le t_{f}
$$

找到一个切换时刻$t_{1}$ 和一个连续输入 u

满足:
* 最小化代价方程$$
J = \underbrace{\frac{1}{2}x(t_{f})^{T}Q_{f}x(t_{f})+M_{f}x(t_{f})+W_{f})}_{\varPsi} + \int_{t_{0}}^{t_{f}}\underbrace{(\frac{1}{2}x^{T}Qx+x^{T}Vu+\frac{1}{2}u^{T}Ru +Mx +Nu+ W)}_{L(x,u)}dt
$$

## 问题五 GSLQ等价问题
已知:
* 一个系统

在区间 $\tau \in [0,1)$ 
$$
\frac{dx(\tau)}{d\tau} = (x_{n+1}-t_{0})(A_{1}x+B_{1}u)
$$
$$
\frac{dx_{n+1}}{d\tau} = 0
$$

在区间 $\tau \in [1,2]$ 
$$
\frac{dx(\tau)}{d\tau} = (t_{f}-x_{n+1})(A_{2}x+B_{2}u)
$$
$$
\frac{dx_{n+1}}{d\tau} = 0
$$

找到一个 a $x_{n+1}$ 和 $u_{\tau}$
满足:
* 最小化
$$
J = \underbrace{\frac{1}{2}x(2)^{T}Q_{f}x(2)+M_{f}x(2)+W_{f})}_{\varPsi} + \int_{0}^{1}(x_{n+1}-t_{0})L(x,u)d\tau + \int_{1}^{2}(t_{f} - x_{n+1})L(x,u)d\tau
$$

假设:
* the optimal value function 值函数:$$
V^{*}(x,\tau,x_{n+1}) = \frac{1}{2}x^{T}P(\tau,x_{n+1})x + S(\tau,x_{n+1})x+T(\tau,x_{n+1})
$$
* 计算 HJB function: 
    * HJB计算公式
    $$
    -\frac{\partial V^{\star}}{\partial t}(x,t) = min_{u}\{F+\frac{\partial V^{\star}}{\partial t}f\}
    $$

    * 在区间 $\tau \in [0,1]$
$$
-\frac{\partial V^{\star}}{\partial \tau}(x,\tau,x_{n+1}) = min_{u(\tau)}\{(x_{n+1}-t_{0})(L(x,u)+\frac{\partial V^{\star}}{\partial x}(x,\tau,x_{n+1})f_{1}(x,u))\}
$$
    * 在区间 $\tau \in [1,2]$
$$
-\frac{\partial V^{\star}}{\partial \tau}(x,\tau,x_{n+1}) = min_{u(\tau)}\{(t_{f}-x_{n+1})(L(x,u)+\frac{\partial V^{\star}}{\partial x}(x,\tau,x_{n+1})f_{2}(x,u))\}
$$

上边HJB 方程的解为:$$
u(x,\tau,x_{n+1}) = R^{-1}(B_{k}^{T}P(\tau,x_{n+1})+V^{T})x(\tau,x_{n+1})-R^{-1}(B_{k}^{T}S^{T}(\tau,x_{n+1})+N^{T})
$$

&emsp;&emsp;其中，$P,S,T$满足$(60)-(65)$式和代价函数(66),接着引入参数化方法计算对$x_{n+1}$的微分项$(67)-(73)$.最终再加上$(74)-(79)$的边界条件整体构成一个常微分方程组用 ***Runge-Kutta method*** 求解.

&emsp;&emsp;这就是基于参数化方法的最优化理论在切换系统中的应用。

## 心得体会
&emsp;&emsp;通过一个学期的最优化理论和最优控制课程的学习，我学到了这种优化的思维方法，即首先将问题转化为一个一般的凸优化问题然后再利用我们学到的各类优化方法来求解凸优化问题，还学到了各类的优化方法比如最速下降发、Newton法、共轭梯度法还有动态规划等等。希望以后能够在科研和实践中多多使用今日之所学。

