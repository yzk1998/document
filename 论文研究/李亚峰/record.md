# $\color{blue}\text{Record}$

## 有限时间控制

###==Lemma 2.3== :
Given:
* scale system $$
\dot{y} = -\alpha y^{\frac{m}{n}}-\beta y^{\frac{p}{q}},y(0) = y_{0}
$$
* $m,n,p,q$ 正奇数
* $m>n,p<q,\alpha > 0 ,\beta > 0$

then
* 系统全局有限时间稳定
* 固定时间设定值$T<T_{maax}:=\frac{1}{\alpha}\frac{n}{m-n}+\frac{1}{\beta}\frac{q}{q-p}$

注意到:
* 对上述系统而言$\frac{m}{n} \le 1,\frac{p}{q} \ge 1$,而同时$\alpha ,\beta 都为正数$,那我自然的会想这种固定时间稳定和之前学过的指数稳定有什么区别?

> 看起来,由于$y$的大小未知，$y^{\frac{m}{n}}$并不能放到$y$，所以好像并不能知道是否指数稳定，也就是说无关?


Q:
* 为什么非要$q>p$，为啥不能交换一下变量的含义,之前$p,q$还在那里出现了?
> 看起来只是想让$m$和$p$当分子

==Lemma 2.1==:
Given:
* 正奇整数$p<q$,定义$b=\frac{p}{q} \le 1$

then:
*  $$
|x^{b}-y^{b}| \le 2^{1-b}|x-y|^{b}
$$

看起来只是一个放缩方法,上面Lemma 2.3的已知中满足了$p<q$，估计大概率后面要用这个引理做一次放缩.

==Definition 2.1==:
Given: 
* $\dot{x} = f(x,t),f(0,t) = 0,x \in R^{n}$
* $f(x,t)$关于x连续
* 系统Lyapunov稳定,存在设定时间$T$

such that:
* 对于任意的初始状态$x(t_{0}) = x_{0}$,有$\lim\limits_{t \rarr T}x(t,t_{0},x_{0}) = 0$

then : 
* 系统全局有限时间稳定

## 有限时间控制器设计

==命题2.1:==

证明:
$$
x_{ij}^{\frac{1}{q_{2}}} = \xi_{ij} + x_{ij}^{\frac{1}{q_{j}}}
$$
$$
x_{ij} = (\xi_{ij} + x_{ij}^{*\frac{1}{q_{j}}})^{q_{j}}
$$
$$
|x_{ij}| = |(\xi_{ij} + x_{ij}^{*\frac{1}{q_{j}}})|^{q_{j}}
$$
$$
\le (|\xi_{ij}| + |x_{ij}|^{\frac{1}{q_{j}}})^{q_{j}}
$$
$$
= (|\xi_{ij}| + |\xi_{i(j-1)}\beta_{i(j-1)}|^{\frac{1}{q_{j}}})^{q_{j}}
$$
Lemma 2.2
$$
\le max\{2^{q-1},1\}(|\xi_{i(j-1)}|^{q_{j}} + |\xi_{i(j-1)}\beta_{i(j-1)}|)
$$
$$
\le |\xi_{i(j-1)}|^{q_{j}} + |\xi_{i(j-1)}|\beta_{i(j-1)}|
$$
得证

==命题2.2:==








