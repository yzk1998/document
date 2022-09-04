<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [verilog编程规范](#verilog编程规范)
  - [工程组织形式](#工程组织形式)
  - [输入输出定义](#输入输出定义)
  - [parameter定义](#parameter定义)
  - [wire/reg定义](#wirereg定义)
  - [信号命名](#信号命名)
  - [always块描述方式](#always块描述方式)
  - [assign块](#assign块)
  - [模块例化](#模块例化)
  - [其他](#其他)

<!-- /code_chunk_output -->



# verilog编程规范

## 工程组织形式

```
XX工程
    |--doc  一般存放工程相关的文档，包括该项目用到的datasheet（数据手册）、设计方案等
    |--par  主要存放工程文件
    |--rtl  主要存放工程的rtl代码，这是工程的核心，文件名与module名称应当一致
    |--sim  主要存放工程的仿真代码
```

## 输入输出定义

1. 一行只定义一个信号
2. 信号全部对齐
3. 同一组的信号放在一起
```verilog
module led( 
    input               sys_clk  ,  //系统时钟 
    input               sys_rst_n,  //系统复位，低电平有效 
    output  reg  [3:0]  led         //4位LED灯 
    ); 
```

## parameter定义

1. 将parameter定义放在紧跟着module的输入输出定义之后
2. 命名全部使用大写


## wire/reg定义

1. 将reg与wire的定义放在紧跟着parameter之后
2. 建议具有相同功能的信号集中放在一起
3. 信号需要对齐
4. 信号需要对齐
5. 一行只定义一个信号


## 信号命名

1. 内部信号全部使用小写
2. 模块名字使用小写
3. 低电平有效的信号，使用_n作为信号后缀
4. 异步信号，使用_a作为信号后缀
5. 纯延迟打拍信号使用_dly作为后缀

## always块描述方式
1. 一个always需要配一个`begin`和`end`，`beign`建议和`always`放在同一行
2. 时钟复位触发描述使用`posedge sys_clk`和`negedge sys_rst_n`
3. 一个always块只包含一个时钟和复位
4. 时序逻辑使用非阻塞赋值

## assign块
1. assign的逻辑不能太复杂，否则易读性不好
2. 组合逻辑使用阻塞赋值

## 模块例化

1. moudle模块例化使用u_xx表示

## 其他

1. 不使用repeat等循环语句
2. RTL级别代码里面不使用initial语句，仿真代码除外
3. 避免产生Latch锁存器，比如组合逻辑里面的if不带else分支、case缺少default语句
4. 避免使用太复杂和少见的语法，可能造成语法综合器优化力度较低







































































































