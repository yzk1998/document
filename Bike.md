# 平衡自行车源码学习

## 主程序

### 预处理指令
```C
#include "sys.h"
```
包含了头文件`sys.h`
#### 细说`sys.h`
```C
#define SYSTEM_SUPPORT_UCOS		0		//定义系统文件夹是否支持UCOS
```
引用一篇博文[什么是UCOS](https://blog.csdn.net/qq_35656655/article/details/119077550 "什么是UCOS")。
> 一句话概括ucos系统：一款源代码开放的，抢占式多任务实时操作系统。

此处不支持UCOS。

```C
//位带操作,实现51类似的GPIO控制功能
//具体实现思想,参考<<CM3权威指南>>第五章(87页~92页).
//IO口操作宏定义
#define BITBAND(addr, bitnum) ((addr & 0xF0000000)+0x2000000+((addr &0xFFFFF)<<5)+(bitnum<<2)) 
#define MEM_ADDR(addr)  *((volatile unsigned long  *)(addr)) 
#define BIT_ADDR(addr, bitnum)   MEM_ADDR(BITBAND(addr, bitnum)) 
```
位带操作简言之就是通过**位带区**和**位带别名区**来通过不同地址访问同一块内存。细说就是将位带区的一比特扩充为位带别名区的一个字，以达到对位带区中单个位的便捷访问。

```C
#define BITBAND(addr, bitnum) ((addr & 0xF0000000)+0x2000000+((addr &0xFFFFF)<<5)+(bitnum<<2)) 
```
用于将位带地址，位序号转化为别名地址的宏。其中`addr`为将自己指定的位带区地址。

```C
#define MEM_ADDR(addr) *((volatile unsigned long *) (adr))
```
用于将指定的地址转化为一个指针。值得注意的是`volatile`关键词。<br>
`volatile`:
1. 本身含义为易变的，用来告诉编译器对访问该变量的代码就不再进行优化，从而可以提供对特殊地址的稳定访问。
2. 在此处使用的原因为因为 C 编译器并不知道同一个比特可以有两个地址。所以就要通过 volatile，使得编译器每次都如实地把新数值写入存
储器，而不再会出于优化的考虑，在中途使用寄存器来操作数据的复本，直到最后才把复本写回——这会导致按不同的方式访问同一个位会得到不一致的结果（可能被优化到不同的寄存器来保存中间结果——译注）
```C
#define BIT_ADDR(addr, bitnum)   MEM_ADDR(BITBAND(addr, bitnum)) 
```
这句就是将以上两句结合直接得到位带地址中相应位序号的指针。<br>
```C
//IO口地址映射
#define GPIOA_ODR_Addr    (GPIOA_BASE+12) //0x4001080C 
#define GPIOB_ODR_Addr    (GPIOB_BASE+12) //0x40010C0C 
#define GPIOC_ODR_Addr    (GPIOC_BASE+12) //0x4001100C 
#define GPIOD_ODR_Addr    (GPIOD_BASE+12) //0x4001140C 
#define GPIOE_ODR_Addr    (GPIOE_BASE+12) //0x4001180C 
#define GPIOF_ODR_Addr    (GPIOF_BASE+12) //0x40011A0C    
#define GPIOG_ODR_Addr    (GPIOG_BASE+12) //0x40011E0C    

#define GPIOA_IDR_Addr    (GPIOA_BASE+8) //0x40010808 
#define GPIOB_IDR_Addr    (GPIOB_BASE+8) //0x40010C08 
#define GPIOC_IDR_Addr    (GPIOC_BASE+8) //0x40011008 
#define GPIOD_IDR_Addr    (GPIOD_BASE+8) //0x40011408 
#define GPIOE_IDR_Addr    (GPIOE_BASE+8) //0x40011808 
#define GPIOF_IDR_Addr    (GPIOF_BASE+8) //0x40011A08 
#define GPIOG_IDR_Addr    (GPIOG_BASE+8) //0x40011E08 
```
以上就是将`GPIOX`的`ODR`和`IDR`做了宏定义方便一会使用。

```C
//IO口操作,只对单一的IO口!
//确保n的值小于16!
#define PAout(n)   BIT_ADDR(GPIOA_ODR_Addr,n)  //输出 
#define PAin(n)    BIT_ADDR(GPIOA_IDR_Addr,n)  //输入 

#define PBout(n)   BIT_ADDR(GPIOB_ODR_Addr,n)  //输出 
#define PBin(n)    BIT_ADDR(GPIOB_IDR_Addr,n)  //输入 

#define PCout(n)   BIT_ADDR(GPIOC_ODR_Addr,n)  //输出 
#define PCin(n)    BIT_ADDR(GPIOC_IDR_Addr,n)  //输入 

#define PDout(n)   BIT_ADDR(GPIOD_ODR_Addr,n)  //输出 
#define PDin(n)    BIT_ADDR(GPIOD_IDR_Addr,n)  //输入 

#define PEout(n)   BIT_ADDR(GPIOE_ODR_Addr,n)  //输出 
#define PEin(n)    BIT_ADDR(GPIOE_IDR_Addr,n)  //输入

#define PFout(n)   BIT_ADDR(GPIOF_ODR_Addr,n)  //输出 
#define PFin(n)    BIT_ADDR(GPIOF_IDR_Addr,n)  //输入

#define PGout(n)   BIT_ADDR(GPIOG_ODR_Addr,n)  //输出 
#define PGin(n)    BIT_ADDR(GPIOG_IDR_Addr,n)  //输入
```
到此为止，我还是没明白是如何通过位带别名区为位带区赋值的。


#### 外部中断？
```C
#define GPIO_A 0
#define GPIO_B 1
#define GPIO_C 2
#define GPIO_D 3
#define GPIO_E 4
#define GPIO_F 5
#define GPIO_G 6 

#define FTIR   1  //下降沿触发
#define RTIR   2  //上升沿触发
```


#### 头文件包含
```C
#include "delay.h"
#include "led.h"
#include "key.h"
#include "oled.h"
#include "usart.h"
#include "usart3.h"
#include "adc.h"
#include "timer.h"
#include "motor.h"
#include "encoder.h"
#include "ioi2c.h"
#include "mpu6050.h"
#include "show.h"								   
#include "exti.h"
#include "DataScope_DP.h"
#include "stmflash.h"  


#include "inv_mpu.h"
#include "inv_mpu_dmp_motion_driver.h"
#include "dmpKey.h"
#include "dmpmap.h"
#include <string.h> 
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
```


#### JTAG
```C
//JTAG模式设置定义
//JTAG模式设置定义
#define JTAG_SWD_DISABLE   0X02
#define SWD_ENABLE         0X01
#define JTAG_SWD_ENABLE    0X00	
#define ZHONGZHI 1
```

#### 函数声明
```C
extern u8 Way_Angle;                             //获取角度的算法，1：四元数  2：卡尔曼  3：互补滤波 
extern u8 Flag_Qian,Flag_Hou,Flag_Left,Flag_Right; //蓝牙遥控相关的变量
extern u8 Flag_Stop,Flag_Show,Flag_Angle;       //停止标志位和 显示标志位 默认停止 显示打开
extern int Encoder;            									 //左右编码器的脉冲计数
extern int Motor,Servo;                           //电机PWM变量
extern int Velocity;                            	//显示温度
extern int Voltage,Zhongzhi;                                //电池电压采样相关的变量
extern float Angle_Balance,Gyro_Balance,Gyro_Turn; //平衡倾角 平衡陀螺仪 转向陀螺仪
extern float Show_Data_Mb;                         //全局显示变量，用于显示需要查看的数据
extern u8 delay_50,delay_flag,PID_Send,Flash_Send,Direction;//延时和调参等变量
extern float Acceleration_Z;                       //Z轴加速度计  
extern float Balance_Kp,Balance_Kd,Balance_Ki,Velocity_Kp,Velocity_Ki;//PID参数
extern u16 PID_Parameter[10],Flash_Parameter[10];  //Flash相关数组
/////////////////////////////////////////////////////////////////  
void Stm32_Clock_Init(u8 PLL);  //时钟初始化  
void Sys_Soft_Reset(void);      //系统软复位
void Sys_Standby(void);         //待机模式 	
void MY_NVIC_SetVectorTable(u32 NVIC_VectTab, u32 Offset);//设置偏移地址
void MY_NVIC_PriorityGroupConfig(u8 NVIC_Group);//设置NVIC分组
void MY_NVIC_Init(u8 NVIC_PreemptionPriority,u8 NVIC_SubPriority,u8 NVIC_Channel,u8 NVIC_Group);//设置中断
void Ex_NVIC_Config(u8 GPIOx,u8 BITx,u8 TRIM);//外部中断配置函数(只对GPIOA~G)
void JTAG_Set(u8 mode);
//////////////////////////////////////////////////////////////////////////////
//以下为汇编函数
void WFI_SET(void);		//执行WFI指令
void INTX_DISABLE(void);//关闭所有中断
void INTX_ENABLE(void);	//开启所有中断
void MSR_MSP(u32 addr);	//设置堆栈地址
```


### 全局变量定义
```C
u8 Way_Angle=1;                             //获取角度的算法，1：四元数  2：卡尔曼  3：互补滤波  
u8 Flag_Qian,Flag_Hou,Flag_Left,Flag_Right; //蓝牙遥控相关的变量
u8 Flag_Stop=1,Flag_Show=0,Flag_Angle;                 //停止标志位和 显示标志位 默认停止 显示打开
int Encoder;             //左右编码器的脉冲计数
int Motor,Servo;                           //电机PWM变量
int Velocity;                            	//显示温度
int Voltage;                                //电池电压采样相关的变量
float Angle_Balance,Gyro_Balance,Gyro_Turn; //平衡倾角 平衡陀螺仪 转向陀螺仪
float Show_Data_Mb;                         //全局显示变量，用于显示需要查看的数据
u8 delay_50,delay_flag,PID_Send,Flash_Send,Direction;//延时和调参等变量
float Acceleration_Z;                       //Z轴加速度计  
float Balance_Kp=8.75,Balance_Kd=0.06,Balance_Ki=0.0,Velocity_Kp=0.6,Velocity_Ki=0.88;//PID参数
u16 PID_Parameter[10],Flash_Parameter[10];  //Flash相关数组
int Zhongzhi=1;
```
注意点：
* 此处定义的是全局变量，后面在其他头文件中应该大概率会看到`extern`的外部变量声明。
* 这里各个变量的定义先不深究，等到到后面具体代码里再研究。

### 主函数
```C
int main(void)
{ 
	Stm32_Clock_Init(9);            //=====系统时钟设置
	delay_init(72);                 //=====延时初始化
	JTAG_Set(SWD_ENABLE);           //=====打开SWD接口 可以利用主板的SWD接口调试
	LED_Init();                     //=====初始化与 LED 连接的硬件接口
	KEY_Init();                     //=====按键初始化
	OLED_Init();                    //=====OLED初始化
	uart_init(72,128000);           //=====初始化串口1
    uart3_init(36,9600);            //=====串口3初始化
    MiniBalance_PWM_Init(7199,0);   //=====初始化PWM 10KHZ，
	Encoder_Init_TIM2();            //=====编码器接口
	Adc_Init();                     //=====adc初始化
	IIC_Init();                     //=====模拟IIC初始化
    MPU6050_initialize();           //=====MPU6050初始化	
    DMP_Init();                     //=====初始化DMP     
	Servo_PWM_Init(9999,144);   	//=====初始化PWM50HZ驱动 舵机
 	EXTI_Init();                    //=====MPU6050 5ms定时中断初始化
	while(1)
		{     
            if(Flash_Send==1)       //写入PID参数到Flash,由app控制该指令
                {
                    Flash_Write();	
                    Flash_Send=0;	
                }	
            if(Flag_Show==0)         //使用MiniBalance APP和OLED显示屏
                {
                    APP_Show();	
                    oled_show();     //===显示屏打开
                }
            else                     //使用MiniBalance上位机 上位机使用的时候需要严格的时序，故此时关闭app监控部分和OLED显示屏
                {
                    DataScope();     //开启MiniBalance上位机
                }	
            delay_flag=1;	
            delay_50=0;
            while(delay_flag);	     //通过MPU6050的INT中断实现的50ms精准延时				
		} 
}
```

























