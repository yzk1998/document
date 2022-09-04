# Verilog 语法复习笔记（一）

## 逻辑值
* 0: 低电平
* 1: 高电平
* X：未知(可能为高电平也可能为低电平)
* Z: 高阻态(对外部相当于断开)
___


## 标识符

### 命名规则
1. 字母、数字、$、_
2. 首字符必须为字母或者下划线
3. 区分大小写

### 规范建议
1. 使用有意义的名字
2. 采用一些前后缀比如：
   * 时钟采用`clk`前缀：`clk_50m`，`clk_cpu`
   * 低电平采用_n后缀：`enable_n`
3. 对于特殊重要的信号采用统一缩写，如`rst`
4. 同意信号在不同层次要保持一致
5. 参数统一大写

### 数字
1. 默认形式为32位十进制
2. * 4'b0101表示4位二进制数0101
   * 4'd2表示4位十进制数字2
   * 4'ha表示4位十六进制数字a

疑问：此处所指的位数是本进制数字的位数，还是二进制数字的位数？

### ***数据类型***
主要分为三大数据类型：
* 寄存器类型
* 线网类型
* 参数类型

#### 寄存器类型
含义：表示一个抽象的数据存储单元<br>

注意点：
1. 只能在always语句和initial语句中被赋值
2. 默认值为X
3. 若过程语句描述的是时序逻辑，则寄存器变量为寄存器；而若描述的是组合逻辑，则寄存器变量为对应的硬件连线。

常见寄存器数据类型:`reg`,`integer`,`real`等

疑问：过程语句？

#### 线网类型
含义：表示verilog结构化原件间的物理连线。

注意点：
1. 线网类型的值由驱动元件的值决定
2. 默认值为Z

常见线网类型：`wire`,`tri`等

#### 参数类型
含义：常量

注意点：
1. 参数的定义是局部的，只在当前模块下有效。
2. 关键字`parameter`

### 运算符
按功能可以分为7类运算符：
* 算术运算符
* 关系运算符
* 逻辑运算符
* 条件运算符
* 位运算符
* 拼接运算符
#### 算术运算符

1. `+`
2. `-`
3. `*`
4. `/`
5. `%`

#### 关系运算符

1. `>`
2. `<`
3. `>=`
4. `<=`
5. `==`
6. `!=`

#### 逻辑运算符

1. `!`
2. `&&`
3. `||`

#### 条件运算符
1. `?:`

#### 位运算符
1. `~`
2. `&`
3. `|`
4. `^`

#### 移位运算符
1. `<<`
2. `>>`

#### 拼接运算符
1. `{}`

#### 运算符优先级

<div align="center">
<img src=./运算符优先级.PNG />
</div>

### 程序框架

#### 注释(与c语言相同)

#### 关键字

<div align="center">
<img src=./keyword.PNG />
</div>

#### 程序框架

框架例程
```verilog
module led( 
    input               sys_clk  ,  //系统时钟 
    input               sys_rst_n,  //系统复位，低电平有效 
    output  reg  [3:0]  led         //4位LED灯 
    ); 


//parameter define 
parameter  WIDTH     = 25        ;  //位宽
parameter  COUNT_MAX = 25_000_000;  //板载50M时钟=20ns，0.5s/20ns=25000000，需要25bit 

//reg define 
reg    [WIDTH-1:0]  counter     ; 
reg    [1:0]        led_ctrl_cnt; 

//wire define 
wire                counter_en  ; 

//*********************************************************************************** 
//**                                 main code 
//*********************************************************************************** 

//计数到最大值时产生高电平使能信号 
assign  counter_en = (counter == (COUNT_MAX - 1'b1))  ?  1'b1  :  1'b0;   

//用于产生0.5秒使能信号的计数器 
always @(posedge sys_clk or negedge sys_rst_n) begin 
    if (sys_rst_n == 1'b0) 
        counter <= 1'b0; 
    else if (counter_en) 
        counter <= 1'b0; 
    else 
        counter <= counter + 1'b1; 
end 
//led流水控制计数器 
always @(posedge sys_clk or negedge sys_rst_n) begin 
    if (sys_rst_n == 1'b0) 
        led_ctrl_cnt <= 2'b0; 
    else if (counter_en) 
        led_ctrl_cnt <= led_ctrl_cnt + 2'b1; 
end 

//通过控制IO口的高低电平实现发光二极管的亮灭 
always @(posedge sys_clk or negedge sys_rst_n) begin 
    if (sys_rst_n == 1'b0) 
        led <= 4'b0; 
    else begin 
        case (led_ctrl_cnt)                  
            2'd0 : led <= 4'b0001; 
            2'd1 : led <= 4'b0010; 
            2'd2 : led <= 4'b0100; 
            2'd3 : led <= 4'b1000; 
            default : ; 
        endcase 
    end 
end 

endmodule
```
以下对上述代码块进行详细说明:<br>

首先提出一个概念***模块级例化语句***，它是结构建模中最常用的方式。模块是Verilog 中基本单元的定义形式，是与外界交互的接口。
```verilog
module module_name 
#(parameter_list) //参数可选
(port_list) ;  //端口列表、端口声明
        ;//Declarations_and_Statements
endmodule
```
参数和变量定义
```verilog
//parameter define 
parameter  WIDTH     = 25        ;  //位宽
parameter  COUNT_MAX = 25_000_000;  //板载50M时钟=20ns，0.5s/20ns=25000000，需要25bit 

//reg define 
reg    [WIDTH-1:0]  counter     ; 
reg    [1:0]        led_ctrl_cnt; 

//wire define 
wire                counter_en  ; 
```
进入代码主体
```verilog
 //计数到最大值时产生高电平使能信号 
 assign  counter_en = (counter == (COUNT_MAX - 1'b1))  ?  1'b1  :  1'b0;   
```
第一句通过条件运算符实现当计满时`counter_en`高电平，未满时低电平。以下说明`assign`：<br>
`assign`用于连续赋值语句用于为`wire`类型赋值
```verilog
assign     LHS_target = RHS_expression  ；//LHS必须为wire类型，RHS类型任意
```
`wire`类型变量也可以在声明时直接赋值，因为`wire`类型变量只可以赋值一次所以两种方式效果相同。

```verilog
//用于产生0.5秒使能信号的计数器 
always @(posedge sys_clk or negedge sys_rst_n) begin 
    if (sys_rst_n == 1'b0) 
        counter <= 1'b0; 
    else if (counter_en) 
        counter <= 1'b0; 
    else 
        counter <= counter + 1'b1; 
end 
```
`always`属于过程结构语句，以下介绍过程结构语句:（引用自菜鸟教程）<br>
* 过程结构语句有 2 种，`initial` 与 `always` 语句。它们是行为级建模的 2 种基本语句。
* 一个模块中可以包含多个 `initial` 和 `always` 语句，但 2 种语句不能嵌套使用。
* 这些语句在模块间并行执行，与其在模块的前后顺序没有关系。
* 但是 `initial` 语句或 `always` 语句内部可以理解为是顺序执行的（非阻塞赋值除外）。
* 每个 `initial` 语句或 `always` 语句都会产生一个独立的控制流，执行时间都是从 0 时刻开始。

1. `initial`语句
    * `initial` 语句从 0 时刻开始执行，只执行一次，多个 `initial` 块之间是相互独立的。
    * 如果 `initial` 块内包含多个语句，需要使用关键字 `begin` 和 `end` 组成一个块语句。
    * 如果 `initial` 块内只要一条语句，关键字 `begin` 和 `end` 可使用也可不使用。
    * `initial` 理论上来讲是不可综合的，多用于初始化、信号检测等。
2. `always`语句
    * 与 initial 语句相反，always 语句是重复执行的。always 语句块从 0 时刻开始执行其中的行为语句；当执行完最后一条语句后，便再次执行语句块中的第一条语句，如此循环反复。

`posedge`为positive edge的缩写即上升沿，同理`negedge`为negitive edge下降沿的缩写。这就引出了verilog的时序控制。<br>
1. 时延控制`#delay procedural_statement`
2. 事件控制 一般用符号`@`来表示
   1. 一般事件触发
      1. 使用方法`always @(clk) q <= d ;`clk只要变化就触发
      2. `always @(posedge clk) q <= d ; `clk上升沿触发
      3. `always @(negedge clk) q <= d ;`clk下降沿触发
      4. `q = @(posedge clk) d ; `clk上升沿将d赋值给q，不推荐写法
   2. 命名事件触发 会用到`event`类型变量，暂时不触及
   3. 敏感列表 采用关键字`or`或`,`来连接多个能够触发的事件,如`always @(posedge clk or negedge rstn)q <= d;`
3. 边沿触发
4. 电平触发







