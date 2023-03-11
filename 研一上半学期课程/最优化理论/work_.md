#  &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;最优化理论结课报告
  
  
我将介绍一种基于参数化方法的最优化理论在切换系统中的应用。
  
##  背景意义
  
  
&emsp;&emsp;经典控制理论按照输入信号和输出信号的时间特性将自动控制系统划分为连续时间控制系统和离散时间控制系统。然而，随着科技进步，现代工程控制系统日益复杂，很多实际复杂系统的动态行为同时包含连续时间系统动力学行为和离散时间系统动力学行为，例如电压电流根据基尔霍夫定律连续变化的电子电路受到切换开关影响发生离散化行为，构成切换电子电路系统。这种同时具有连续和离散动态特性的动力特性的动力系统成为混杂动力系统。
  
&emsp;&emsp;除了上述提到的切换电子电路系统外，混杂动力系统广泛分布于现实中各类工程应用系统中，如存在碰撞行为的机械物理运动系统，多齿轮转换的齿轮传动系统，网络传输控制系统，混合动力汽车等。状态传输时延，外部扰动等等，都将对混杂动态产生不同于单纯离散时间系统或连续时间系统的影响，因此针对混杂系统的分析与设计通常比单纯的离散动态或单纯的连续动态更加困难。由于混杂动态系统的广泛应用及分析综合方面存在较多挑战，近几十年来针对混杂系统的研究越来越受到人们的关注。
  
&emsp;&emsp;在众多的混杂动态系统中，有一类特殊的系统更加受到国内外研究学者的关注：切换系统。切换系统由有限连续或离散的子系统以及按照某一规则选择特定子系统处于激活工作状态的切换信号或切换律组成。在任意的时间区间内，有且仅有一个子系统处于激活工作状态，这些子系统通常描述成为微分或差分方程形式。在切换系统中，离散的“跳跃”靠切换信号（切换律）实现，由于切换信号的作用是激活某一特定的子系统，因而一般情况下，切换信号是分段连续的常数映射。
  
&emsp;&emsp;目前，针对切换系统的分类，通常所依据的是其子系统的类别特性，如连续切换系统或离散切换系统，线性切换系统或非线性切换系统等。
  
&emsp;&emsp;作为一类重要的混杂动态系统，切换系统控制在理论和实际系统中的应用极其广泛，例如手动驾驶汽车换挡调速系统，网络拓扑切换下多智能体系统，机器人控制系统等。
  
##  工程问题的建模
  
切换系统基本研究问题一个连续时间切换系统可以描述为如下模型：
<p align="center"><img src="https://latex.codecogs.com/gif.latex?&#x5C;dot{x}%20=%20f_{i}(x,u)"/></p>  
  
切换序列可表示为:
<p align="center"><img src="https://latex.codecogs.com/gif.latex?&#x5C;sigma%20=%20((t_{0},i_{0}),(t_{1},i_{1}),&#x5C;dots,(t_{K},i_{K}))"/></p>  
  
&emsp;&emsp;其中,<img src="https://latex.codecogs.com/gif.latex?x(t)∈R^m"/>分别为系统的状态和控制输入，<img src="https://latex.codecogs.com/gif.latex?σ(t):[0,+∞)→P=&#x5C;{1,…,p&#x5C;}"/>是分段右连续切换信号.在各类理论分析与工程应用系统中，一般来讲，切换规则通常分为基于时间切换，基于状态切换或基于记忆切换(基于曾经激活的模态)三类。<img src="https://latex.codecogs.com/gif.latex?f_i%20(x(t),u(t)):R^n→R^n"/> 为光滑向量函数,<img src="https://latex.codecogs.com/gif.latex?i=σ(t)"/>其中表示在t时刻运行的子系统，或称在t时刻激活的模态，即若则表示系统状态轨迹将沿着模态的动态方程运动。
  
&emsp;&emsp;系统稳定性是系统控制与设计的基本问题。如何保证各系统存在切换条件下整个切换系统的稳定性仍是当前针对切换系统研究的重点。然而，切换信号的存在，使得切换系统稳定性分析与设计更加复杂。这体现在对于子系统全都稳定的切换系统，在任意切换下闭环系统状态可能发散变得不稳定。因此在切换的过程中可能会产生一定的由于切换而产生的能量被系统吸收，如果切换的过于频繁，则有可能造成系统吸收能量过多从而无法维持稳定。另外，若系统中含有不稳定的子系统，则在系统切换过于频繁或该不稳定子系统驻留时间过长，整个系统也会变得不稳定。
  
##  切换系统最优控制问题的建立
  
  
###  问题一
  
已知:
* 子系统模型 <img src="https://latex.codecogs.com/gif.latex?&#x5C;dot{x}=f_{i}(x,u)"/>
* 一端固定的时间区间 <img src="https://latex.codecogs.com/gif.latex?[t_{0},t_{f}]"/>
* 一段已经指定好的切换序列 <img src="https://latex.codecogs.com/gif.latex?&#x5C;sigma%20=%20((t_{0},i_{0}),(t_{1},i_{1}),&#x5C;dots,(t_{K},i_{K}))"/>
* <img src="https://latex.codecogs.com/gif.latex?x(t_{0})=x_{0}"/>
* 在 <img src="https://latex.codecogs.com/gif.latex?t_{f}"/>满足<img src="https://latex.codecogs.com/gif.latex?S_{f}"/>
  
我们需要找到一个连续输入<img src="https://latex.codecogs.com/gif.latex?u%20&#x5C;in%20U_{[t_{0},t_{f}]}"/> 和切换时刻 <img src="https://latex.codecogs.com/gif.latex?t_{1},&#x5C;dots%20,t_{K}"/>
  
来满足 
* 对代价函数的取最小值 <p align="center"><img src="https://latex.codecogs.com/gif.latex?J%20=%20&#x5C;varPsi(x(t_{f}))%20+%20&#x5C;int_{t_{0}}^{t_{f}}L(x(t),u(t))dt"/></p>  
  
<img src="https://latex.codecogs.com/gif.latex?&#x5C;varPsi"/>为终端部分,<img src="https://latex.codecogs.com/gif.latex?L"/>为积分部分.
  
##  问题拆分
  
将问题一拆分为两部分
  
###  第一部分
  
  
&emsp;&emsp;找到一个最优的连续输入<img src="https://latex.codecogs.com/gif.latex?u"/>和对应的最小的<img src="https://latex.codecogs.com/gif.latex?J"/>。
  
&emsp;&emsp;因为时间区间是固定的，所以找到 <img src="https://latex.codecogs.com/gif.latex?J_{1}(&#x5C;hat{t})"/>  对应的 <img src="https://latex.codecogs.com/gif.latex?&#x5C;hat{t}=(t_{1},&#x5C;dots,t_{k})^{T}"/> 是很容易的。唯一的区别是系统符合的动力学模型随着不同时间区间的变换跟着变换了。
  
####  定理一 问题第一部分的一个必要条件
  
假设:
* 子系统k在区间<img src="https://latex.codecogs.com/gif.latex?[t_{k-1},t_{k})"/> ,<img src="https://latex.codecogs.com/gif.latex?k%20&#x5C;in%20[1,K]"/>上被激活.
* 子系统 K+1 在区间 <img src="https://latex.codecogs.com/gif.latex?[t_{K},t_{K+1}]"/>,<img src="https://latex.codecogs.com/gif.latex?t_{K+1}=t_{f}上被激活"/>.
* <img src="https://latex.codecogs.com/gif.latex?u%20&#x5C;in%20U_{[t_{0},t_{f}]}"/> 连续输入满足 <img src="https://latex.codecogs.com/gif.latex?x(t_{0})%20=%20x_{0}"/> 并且满足 <img src="https://latex.codecogs.com/gif.latex?S_{f}%20=%20&#x5C;{x%20|%20&#x5C;varPhi_{f}(x)%20=%200,&#x5C;varPhi%20:%20R^{n}%20&#x5C;rarr%20%20%20R^{l_{f}}&#x5C;}"/> at <img src="https://latex.codecogs.com/gif.latex?t_{f}"/>.
> 即满足 <img src="https://latex.codecogs.com/gif.latex?&#x5C;Phi_f(x(t_{f}))%20=%200"/>
  
为保证u是最优的需要有:
*   存在一个向量函数<img src="https://latex.codecogs.com/gif.latex?p(t)%20=%20[p_{1}(t),&#x5C;dots%20,p_{n}(t)]^{T},t&#x5C;in%20[t_{0},t_{f}]"/> .
  
满足以下条件:
* <img src="https://latex.codecogs.com/gif.latex?H(x,p,u)%20=%20L(x,u)%20+%20p^{T}f_{k}(x,u),"/> <img src="https://latex.codecogs.com/gif.latex?&#x5C;text{for%20any%20}%20t&#x5C;in%20[t_{0},t_{f}]"/>
    1. 状态方程state equations: <img src="https://latex.codecogs.com/gif.latex?&#x5C;frac{dx(t)}{dt}%20=%20(&#x5C;frac{&#x5C;partial%20H}{&#x5C;partial%20p}(x(t),p(t),u(t)))^{T}"/>
    2. 协态方程costate equations: <img src="https://latex.codecogs.com/gif.latex?&#x5C;frac{dp(t)}{dt}%20=%20-(&#x5C;frac{&#x5C;partial%20H}{&#x5C;partial%20x}(x(t),p(t),u(t)))^{T}"/>
    3. 控制方程 stationarity condition: <img src="https://latex.codecogs.com/gif.latex?0%20=%20(&#x5C;frac{&#x5C;partial%20H}{&#x5C;partial%20u}(x(t),p(t),u(t)))^{T}"/>
    4. 横截条件 <img src="https://latex.codecogs.com/gif.latex?p(t_{f})%20=%20&#x5C;frac{&#x5C;partial%20&#x5C;varPsi}{&#x5C;partial%20x}(x(t_{f}))^{T}%20+%20&#x5C;frac{&#x5C;partial%20&#x5C;Phi_{f}}{&#x5C;partial%20x}(x(t_{f}))^{T}%20&#x5C;lambda"/>
    5. 连续性条件<img src="https://latex.codecogs.com/gif.latex?p(t_{k^{-}})%20=%20p(t_{k^{+}})"/>.
  
### 第二部分
  
解决这个受限的非线性最优化问题
<p align="center"><img src="https://latex.codecogs.com/gif.latex?min_{&#x5C;tilde{t}}%20J_{1}(&#x5C;hat{t})%20&#x5C;&#x5C;%20%20%20%20%20&#x5C;text{subject%20to%20}&#x5C;hat{t}%20&#x5C;in%20T"/></p>  
  
  
算法如下:  
1. 设置iteration index <img src="https://latex.codecogs.com/gif.latex?j=0"/>.选择一个初始值 <img src="https://latex.codecogs.com/gif.latex?&#x5C;tilde{t}^{j}"/>.
2. 解这个最优控制问题 .
3. 找到 <img src="https://latex.codecogs.com/gif.latex?&#x5C;frac{&#x5C;partial%20J_{1}}{&#x5C;partial%20&#x5C;hat{t}}(&#x5C;tilde{t}^{j})"/> 和 <img src="https://latex.codecogs.com/gif.latex?&#x5C;frac{&#x5C;partial^{2}%20J_{1}}{&#x5C;partial%20&#x5C;hat{t}^{2}}(&#x5C;tilde{t}^{j})"/>.
4. 用一些合理的方向来更新 <img src="https://latex.codecogs.com/gif.latex?&#x5C;tilde{t}^{j}"/> to <img src="https://latex.codecogs.com/gif.latex?&#x5C;tilde{t}^{j+1}"/>.
5. 重复步骤(2),(3),(4),(5).
  
##  问题二
  
已知:
* 一个切换系统 <p align="center"><img src="https://latex.codecogs.com/gif.latex?&#x5C;dot{x}%20=%20f_{1}(x,u),t_{0}%20&#x5C;le%20t&#x5C;le%20t_{1}"/></p>  
  
<p align="center"><img src="https://latex.codecogs.com/gif.latex?&#x5C;dot{x}%20=%20f_{2}(x,u),t_{1}%20&#x5C;le%20t&#x5C;le%20t_{f}"/></p>  
  
* <img src="https://latex.codecogs.com/gif.latex?t_{0}"/>,<img src="https://latex.codecogs.com/gif.latex?t_{f}"/> and <img src="https://latex.codecogs.com/gif.latex?x(t_{0})%20=%20x_{0}"/>
  
找到一个切换时刻 <img src="https://latex.codecogs.com/gif.latex?t_{1}"/> and <img src="https://latex.codecogs.com/gif.latex?u(t)"/>
  
满足 
* 代价函数最小 
<p align="center"><img src="https://latex.codecogs.com/gif.latex?J%20=%20&#x5C;varPsi(x(t_{f}))%20+%20&#x5C;int_{t_{0}}^{t_{f}}L(x,u)dt"/></p>  
  
  
##  问题三 (一个等价问题)
  
***引入*** 一个状态变量 <img src="https://latex.codecogs.com/gif.latex?x_{n+1}"/> 对应着 <img src="https://latex.codecogs.com/gif.latex?t_{1}"/>.
<img src="https://latex.codecogs.com/gif.latex?x_{n+1}"/> 满足
<p align="center"><img src="https://latex.codecogs.com/gif.latex?&#x5C;frac{dx_{n+1}}{dt}%20=%200"/></p>  
  
<p align="center"><img src="https://latex.codecogs.com/gif.latex?x_{n+1}(0)%20=%20t_{1}"/></p>  
  
  
这里 <img src="https://latex.codecogs.com/gif.latex?x_{n+1}"/> 为一常量 <img src="https://latex.codecogs.com/gif.latex?t_{1}"/> ,不过会在下一节中看作未知参数.
  
***引入*** 一个新的独立的时间变量 <img src="https://latex.codecogs.com/gif.latex?&#x5C;tau"/>.
<img src="https://latex.codecogs.com/gif.latex?t"/> 将会变为 <img src="https://latex.codecogs.com/gif.latex?&#x5C;tau"/> 和 <img src="https://latex.codecogs.com/gif.latex?u_{n+1}"/>
<p align="center"><img src="https://latex.codecogs.com/gif.latex?t%20=%20&#x5C;begin{cases}%20%20%20t_{0}+(x_{n+1}-t_{0})&#x5C;tau%20&amp;&#x5C;%20%200%20&#x5C;le%20&#x5C;tau%20&#x5C;le%201%20&#x5C;&#x5C;%20%20%20x_{n+1}+(t_{f}-x_{n+1})(&#x5C;tau%20-1)%20&amp;&#x5C;%20%201%20&#x5C;le%20&#x5C;tau%20&#x5C;le%202&#x5C;end{cases}"/></p>  
  
  
显然<img src="https://latex.codecogs.com/gif.latex?t%20=%20t_{0},&#x5C;tau%20=%200"/>;<img src="https://latex.codecogs.com/gif.latex?t%20=%20t_{1},&#x5C;tau%20=%201"/>;<img src="https://latex.codecogs.com/gif.latex?t%20=%20t_{f},&#x5C;tau%20=%202"/>
  
已知:
* 一个系统 
  
在区间 <img src="https://latex.codecogs.com/gif.latex?&#x5C;tau%20&#x5C;in%20[0,1)"/> 
<p align="center"><img src="https://latex.codecogs.com/gif.latex?&#x5C;frac{dx(&#x5C;tau)}{d&#x5C;tau}%20=%20(x_{n+1}-t_{0})f_{1}(x,u)"/></p>  
  
<p align="center"><img src="https://latex.codecogs.com/gif.latex?&#x5C;frac{dx_{n+1}}{d&#x5C;tau}%20=%200"/></p>  
  
  
在区间 <img src="https://latex.codecogs.com/gif.latex?&#x5C;tau%20&#x5C;in%20[1,2]"/> 
<p align="center"><img src="https://latex.codecogs.com/gif.latex?&#x5C;frac{dx(&#x5C;tau)}{d&#x5C;tau}%20=%20(t_{f}-x_{n+1})f_{2}(x,u)"/></p>  
  
<p align="center"><img src="https://latex.codecogs.com/gif.latex?&#x5C;frac{dx_{n+1}}{d&#x5C;tau}%20=%200"/></p>  
  
* <img src="https://latex.codecogs.com/gif.latex?t_{0}"/>,<img src="https://latex.codecogs.com/gif.latex?t_{f}"/> and <img src="https://latex.codecogs.com/gif.latex?x(0)%20=%20x_{0}"/>
  
满足:
  
* 最小化代价函数
<p align="center"><img src="https://latex.codecogs.com/gif.latex?J%20=%20&#x5C;varPsi(x(2))%20+%20&#x5C;int_{0}^{1}(x_{n+1}-t_{0})L(x,u)d&#x5C;tau%20+%20&#x5C;int_{1}^{2}(t_{f}-x_{n+1})L(x,u)d&#x5C;tau"/></p>  
  
  
##  一种基于解边界值代数微分方程的方法
  
定义:
* <img src="https://latex.codecogs.com/gif.latex?&#x5C;tilde{f_{1}}(x,u,x_{n+1})%20=%20(x_{n+1}-t_{0})f_{1}(x,u)"/>
* <img src="https://latex.codecogs.com/gif.latex?&#x5C;tilde{f_{2}}(x,u,x_{n+1})%20=%20(t_{f}-x_{n+1})f_{2}(x,u)"/>
* <img src="https://latex.codecogs.com/gif.latex?&#x5C;tilde{L_{1}}(x,u,x_{n+1})%20=%20(x_{n+1}-t_{0})L(x,u)"/>
* <img src="https://latex.codecogs.com/gif.latex?&#x5C;tilde{L_{2}}(x,u,x_{n+1})%20=%20(t_{f}-x_{n+1})L(x,u)"/>
  
认为 <img src="https://latex.codecogs.com/gif.latex?x_{n+1}"/> 是参数,<img src="https://latex.codecogs.com/gif.latex?x(&#x5C;tau)&#x5C;rarr%20x(&#x5C;tau,x_{n+1})"/>.
  
* 将哈密顿方程参数化 <p align="center"><img src="https://latex.codecogs.com/gif.latex?H(x,p,u,x_{n+1})%20=%20&#x5C;begin{cases}%20%20%20&#x5C;tilde{L}_{1}(x,u,x_{n+1})+p^{T}&#x5C;tilde{f_{1}}(x,u,x_{n+1})%20&amp;&#x5C;%20%200%20&#x5C;le%20&#x5C;tau%20&#x5C;le%201%20&#x5C;&#x5C;%20%20%20&#x5C;tilde{L}_{2}(x,u,x_{n+1})+p^{T}&#x5C;tilde{f_{2}}(x,u,x_{n+1})%20&amp;&#x5C;%20%201%20&#x5C;le%20&#x5C;tau%20&#x5C;le%202&#x5C;end{cases}"/></p>  
  
  
假设:
* <img src="https://latex.codecogs.com/gif.latex?x_{n+1}"/> 是一个给定的固定未知参数
  
应用定理一到问题三:
1. 状态方程state equ: <img src="https://latex.codecogs.com/gif.latex?&#x5C;frac{&#x5C;partial%20x}{&#x5C;partial%20&#x5C;tau}%20=%20(&#x5C;frac{&#x5C;partial%20H}{&#x5C;partial%20p})^{T}%20=%20&#x5C;tilde{f_{k}}(x,u,x_{n+1})"/>
2. 协态方程costate function: <img src="https://latex.codecogs.com/gif.latex?&#x5C;frac{&#x5C;partial%20p}{&#x5C;partial%20&#x5C;tau}%20=%20-(&#x5C;frac{&#x5C;partial%20H}{&#x5C;partial%20x})^{T}%20=%20-(&#x5C;frac{&#x5C;partial%20&#x5C;tilde{f_{k}}}{&#x5C;partial%20x})^{T}p%20-%20(&#x5C;frac{&#x5C;partial%20&#x5C;tilde{L_{k}}}{&#x5C;partial%20x})^{T}"/>
3. 控制方程 stationarity equ: <img src="https://latex.codecogs.com/gif.latex?0%20=%20(&#x5C;frac{&#x5C;partial%20H}{&#x5C;partial%20u})^{T}%20=%20(&#x5C;frac{&#x5C;partial%20&#x5C;tilde{f_{k}}}{&#x5C;partial%20u})^{T}p+(&#x5C;frac{&#x5C;partial%20&#x5C;tilde{L_{k}}}{&#x5C;partial%20u})^{T}"/>
4. 边界条件 <img src="https://latex.codecogs.com/gif.latex?x(0,x_{n+1})%20=%20x_{0}"/> ; <img src="https://latex.codecogs.com/gif.latex?p(2,x_{n+1})%20=%20(&#x5C;frac{&#x5C;partial%20&#x5C;varPsi}{&#x5C;partial%20x}(x(2,x_{n+1})))^{T}"/>.
5. 连续性条件 <img src="https://latex.codecogs.com/gif.latex?p(1^{-},x_{n+1})%20=%20p(1^{+},x_{n+1})"/>
6. 代价函数 <p align="center"><img src="https://latex.codecogs.com/gif.latex?J(x_{n+1})%20=%20&#x5C;varPsi(x(2,x_{n+1}))%20+%20&#x5C;int_{0}^{1}&#x5C;tilde{L}(x,u,x_{n+1})d&#x5C;tau%20+%20&#x5C;int_{1}^{2}&#x5C;tilde{L}(x,u,x_{n+1})d&#x5C;tau"/></p>  
  
  
将以上方程对 <img src="https://latex.codecogs.com/gif.latex?x_{n+1}"/>微分.
  
##  问题四 (General Switched Linear Quadratic问题)
  
已知:
* 一个切换系统 <p align="center"><img src="https://latex.codecogs.com/gif.latex?&#x5C;dot{x}%20=%20A_{1}x%20+%20B_{1}u,t_{0}%20&#x5C;le%20t%20&#x5C;le%20t_{1}"/></p>  
  
<p align="center"><img src="https://latex.codecogs.com/gif.latex?&#x5C;dot{x}%20=%20A_{2}x%20+%20B_{2}u,t_{1}%20&#x5C;le%20t%20&#x5C;le%20t_{f}"/></p>  
  
  
找到一个切换时刻<img src="https://latex.codecogs.com/gif.latex?t_{1}"/> 和一个连续输入 u
  
满足:
* 最小化代价方程<p align="center"><img src="https://latex.codecogs.com/gif.latex?J%20=%20&#x5C;underbrace{&#x5C;frac{1}{2}x(t_{f})^{T}Q_{f}x(t_{f})+M_{f}x(t_{f})+W_{f})}_{&#x5C;varPsi}%20+%20&#x5C;int_{t_{0}}^{t_{f}}&#x5C;underbrace{(&#x5C;frac{1}{2}x^{T}Qx+x^{T}Vu+&#x5C;frac{1}{2}u^{T}Ru%20+Mx%20+Nu+%20W)}_{L(x,u)}dt"/></p>  
  
  
##  问题五 GSLQ等价问题
  
已知:
* 一个系统
  
在区间 <img src="https://latex.codecogs.com/gif.latex?&#x5C;tau%20&#x5C;in%20[0,1)"/> 
<p align="center"><img src="https://latex.codecogs.com/gif.latex?&#x5C;frac{dx(&#x5C;tau)}{d&#x5C;tau}%20=%20(x_{n+1}-t_{0})(A_{1}x+B_{1}u)"/></p>  
  
<p align="center"><img src="https://latex.codecogs.com/gif.latex?&#x5C;frac{dx_{n+1}}{d&#x5C;tau}%20=%200"/></p>  
  
  
在区间 <img src="https://latex.codecogs.com/gif.latex?&#x5C;tau%20&#x5C;in%20[1,2]"/> 
<p align="center"><img src="https://latex.codecogs.com/gif.latex?&#x5C;frac{dx(&#x5C;tau)}{d&#x5C;tau}%20=%20(t_{f}-x_{n+1})(A_{2}x+B_{2}u)"/></p>  
  
<p align="center"><img src="https://latex.codecogs.com/gif.latex?&#x5C;frac{dx_{n+1}}{d&#x5C;tau}%20=%200"/></p>  
  
  
找到一个 a <img src="https://latex.codecogs.com/gif.latex?x_{n+1}"/> 和 <img src="https://latex.codecogs.com/gif.latex?u_{&#x5C;tau}"/>
满足:
* 最小化
<p align="center"><img src="https://latex.codecogs.com/gif.latex?J%20=%20&#x5C;underbrace{&#x5C;frac{1}{2}x(2)^{T}Q_{f}x(2)+M_{f}x(2)+W_{f})}_{&#x5C;varPsi}%20+%20&#x5C;int_{0}^{1}(x_{n+1}-t_{0})L(x,u)d&#x5C;tau%20+%20&#x5C;int_{1}^{2}(t_{f}%20-%20x_{n+1})L(x,u)d&#x5C;tau"/></p>  
  
  
假设:
* the optimal value function 值函数:<p align="center"><img src="https://latex.codecogs.com/gif.latex?V^{*}(x,&#x5C;tau,x_{n+1})%20=%20&#x5C;frac{1}{2}x^{T}P(&#x5C;tau,x_{n+1})x%20+%20S(&#x5C;tau,x_{n+1})x+T(&#x5C;tau,x_{n+1})"/></p>  
  
* 计算 HJB function: 
    * HJB计算公式
    <p align="center"><img src="https://latex.codecogs.com/gif.latex?-&#x5C;frac{&#x5C;partial%20V^{&#x5C;star}}{&#x5C;partial%20t}(x,t)%20=%20min_{u}&#x5C;{F+&#x5C;frac{&#x5C;partial%20V^{&#x5C;star}}{&#x5C;partial%20t}f&#x5C;}"/></p>  
  
  
    * 在区间 <img src="https://latex.codecogs.com/gif.latex?&#x5C;tau%20&#x5C;in%20[0,1]"/>
<p align="center"><img src="https://latex.codecogs.com/gif.latex?-&#x5C;frac{&#x5C;partial%20V^{&#x5C;star}}{&#x5C;partial%20&#x5C;tau}(x,&#x5C;tau,x_{n+1})%20=%20min_{u(&#x5C;tau)}&#x5C;{(x_{n+1}-t_{0})(L(x,u)+&#x5C;frac{&#x5C;partial%20V^{&#x5C;star}}{&#x5C;partial%20x}(x,&#x5C;tau,x_{n+1})f_{1}(x,u))&#x5C;}"/></p>  
  
    * 在区间 <img src="https://latex.codecogs.com/gif.latex?&#x5C;tau%20&#x5C;in%20[1,2]"/>
<p align="center"><img src="https://latex.codecogs.com/gif.latex?-&#x5C;frac{&#x5C;partial%20V^{&#x5C;star}}{&#x5C;partial%20&#x5C;tau}(x,&#x5C;tau,x_{n+1})%20=%20min_{u(&#x5C;tau)}&#x5C;{(t_{f}-x_{n+1})(L(x,u)+&#x5C;frac{&#x5C;partial%20V^{&#x5C;star}}{&#x5C;partial%20x}(x,&#x5C;tau,x_{n+1})f_{2}(x,u))&#x5C;}"/></p>  
  
  
上边HJB 方程的解为:<p align="center"><img src="https://latex.codecogs.com/gif.latex?u(x,&#x5C;tau,x_{n+1})%20=%20R^{-1}(B_{k}^{T}P(&#x5C;tau,x_{n+1})+V^{T})x(&#x5C;tau,x_{n+1})-R^{-1}(B_{k}^{T}S^{T}(&#x5C;tau,x_{n+1})+N^{T})"/></p>  
  
  
&emsp;&emsp;其中，<img src="https://latex.codecogs.com/gif.latex?P,S,T"/>满足<img src="https://latex.codecogs.com/gif.latex?(60)-(65)"/>式和代价函数(66),接着引入参数化方法计算对<img src="https://latex.codecogs.com/gif.latex?x_{n+1}"/>的微分项<img src="https://latex.codecogs.com/gif.latex?(67)-(73)"/>.最终再加上<img src="https://latex.codecogs.com/gif.latex?(74)-(79)"/>的边界条件整体构成一个常微分方程组用 ***Runge-Kutta method*** 求解.
  
&emsp;&emsp;这就是基于参数化方法的最优化理论在切换系统中的应用。
  
##  心得体会
  
&emsp;&emsp;通过一个学期的最优化理论和最优控制课程的学习，我学到了这种优化的思维方法，即首先将问题转化为一个一般的凸优化问题然后再利用我们学到的各类优化方法来求解凸优化问题，还学到了各类的优化方法比如最速下降发、Newton法、共轭梯度法还有动态规划等等。希望以后能够在科研和实践中多多使用今日之所学。
  
  