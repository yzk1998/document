# 平衡自行车源码学习（二）

## 系统时针设置

```C
//系统时钟初始化函数
//pll:选择的倍频数，从2开始，最大值为16		 
void Stm32_Clock_Init(u8 PLL)
{
	unsigned char temp=0;   
	MYRCC_DeInit();		  //复位并配置向量表
 	RCC->CR|=0x00010000;  //外部高速时钟使能HSEON
	while(!(RCC->CR>>17));//等待外部时钟就绪
	RCC->CFGR=0X00000400; //APB1=DIV2;APB2=DIV1;AHB=DIV1;
	PLL-=2;//抵消2个单位
	RCC->CFGR|=PLL<<18;   //设置PLL值 2~16
	RCC->CFGR|=1<<16;	  //PLLSRC ON 
	FLASH->ACR|=0x32;	  //FLASH 2个延时周期

	RCC->CR|=0x01000000;  //PLLON
	while(!(RCC->CR>>25));//等待PLL锁定
	RCC->CFGR|=0x00000002;//PLL作为系统时钟	 
	while(temp!=0x02)     //等待PLL作为系统时钟设置成功
	{   
		temp=RCC->CFGR>>2;
		temp&=0x03;
	}    
}		    
```

## 延时初始化
```C
void delay_init(u8 SYSCLK)
{
#ifdef OS_CRITICAL_METHOD 	//如果OS_CRITICAL_METHOD定义了,说明使用ucosII了.
	u32 reload;
#endif
 	SysTick->CTRL&=~(1<<2);	//SYSTICK使用外部时钟源	 
	fac_us=SYSCLK/8;		//不论是否使用ucos,fac_us都需要使用
	    
#ifdef OS_CRITICAL_METHOD 	//如果OS_CRITICAL_METHOD定义了,说明使用ucosII了.
	reload=SYSCLK/8;		//每秒钟的计数次数 单位为K	   
	reload*=1000000/OS_TICKS_PER_SEC;//根据OS_TICKS_PER_SEC设定溢出时间
							//reload为24位寄存器,最大值:16777216,在72M下,约合1.86s左右	
	fac_ms=1000/OS_TICKS_PER_SEC;//代表ucos可以延时的最少单位	   
	SysTick->CTRL|=1<<1;   	//开启SYSTICK中断
	SysTick->LOAD=reload; 	//每1/OS_TICKS_PER_SEC秒中断一次	
	SysTick->CTRL|=1<<0;   	//开启SYSTICK    
#else
	fac_ms=(u16)fac_us*1000;//非ucos下,代表每个ms需要的systick时钟数   
#endif
}			
```

## SWD
```C
//JTAG模式设置,用于设置JTAG的模式
//mode:jtag,swd模式设置;00,全使能;01,使能SWD;10,全关闭;	   
//#define JTAG_SWD_DISABLE   0X02
//#define SWD_ENABLE         0X01
//#define JTAG_SWD_ENABLE    0X00		  
void JTAG_Set(u8 mode)
{
	u32 temp;
	temp=mode;
	temp<<=25;
	RCC->APB2ENR|=1<<0;     //开启辅助时钟	   
	AFIO->MAPR&=0XF8FFFFFF; //清除MAPR的[26:24]
	AFIO->MAPR|=temp;       //设置jtag模式
} 
```

## LED

```C
void LED_Init(void)
{
RCC->APB2ENR|=1<<2; //使能 PORTA 时钟  
GPIOA->CRH&=0XFFF0FFFF;
GPIOA->CRH|=0X00030000;//PA12 推挽输出
GPIOA->ODR|=1<<12; //PA12 输出高
}
```

## 按键

```C
void KEY_Init(void)
{
	RCC->APB2ENR|=1<<2;    //使能PORTA时钟	   	 
	GPIOA->CRH&=0X0FFFFFFF; 
	GPIOA->CRH|=0X80000000;//PA15 上拉输入
  GPIOA->ODR|=1<<15; //PA15 上拉	
} 
```
## OLED
```C
void OLED_Init(void)
{ 	
   	 
 	RCC->APB2ENR|=1<<3;    //使能PORTB时钟	   	 
	GPIOB->CRL&=0XFFF0FFFF; 
	GPIOB->CRL|=0X00020000;//PB4 推挽输出   

  RCC->APB2ENR|=1<<4;     	//使能PORTC时钟  
	RCC->APB2ENR|=1<<0;     	//使能AFIO时钟	
	GPIOC->CRH&=0X000FFFFF;	//PC13,14,15设置成输出 2MHz 推挽输出   
	GPIOC->CRH|=0X22200000; 
	PWR->CR|=1<<8;	//取消备份区写保护 
	RCC->BDCR&=0xFFFFFFFE;	//外部低俗振荡器关闭 PC14，PC15成为普通IO	 	
	BKP->CR&=0xFFFFFFFE; 	//侵入检测TAMPER引脚作为通用IO口使用 
	PWR->CR&=0xFFFFFEFF;	//备份区写保护

	OLED_RST_Clr();
	delay_ms(100);
	OLED_RST_Set(); 
					  
	OLED_WR_Byte(0xAE,OLED_CMD); //关闭显示
	OLED_WR_Byte(0xD5,OLED_CMD); //设置时钟分频因子,震荡频率
	OLED_WR_Byte(80,OLED_CMD);   //[3:0],分频因子;[7:4],震荡频率
	OLED_WR_Byte(0xA8,OLED_CMD); //设置驱动路数
	OLED_WR_Byte(0X3F,OLED_CMD); //默认0X3F(1/64) 
	OLED_WR_Byte(0xD3,OLED_CMD); //设置显示偏移
	OLED_WR_Byte(0X00,OLED_CMD); //默认为0

	OLED_WR_Byte(0x40,OLED_CMD); //设置显示开始行 [5:0],行数.
													    
	OLED_WR_Byte(0x8D,OLED_CMD); //电荷泵设置
	OLED_WR_Byte(0x14,OLED_CMD); //bit2，开启/关闭
	OLED_WR_Byte(0x20,OLED_CMD); //设置内存地址模式
	OLED_WR_Byte(0x02,OLED_CMD); //[1:0],00，列地址模式;01，行地址模式;10,页地址模式;默认10;
	OLED_WR_Byte(0xA1,OLED_CMD); //段重定义设置,bit0:0,0->0;1,0->127;
	OLED_WR_Byte(0xC0,OLED_CMD); //设置COM扫描方向;bit3:0,普通模式;1,重定义模式 COM[N-1]->COM0;N:驱动路数
	OLED_WR_Byte(0xDA,OLED_CMD); //设置COM硬件引脚配置
	OLED_WR_Byte(0x12,OLED_CMD); //[5:4]配置
		 
	OLED_WR_Byte(0x81,OLED_CMD); //对比度设置
	OLED_WR_Byte(0xEF,OLED_CMD); //1~255;默认0X7F (亮度设置,越大越亮)
	OLED_WR_Byte(0xD9,OLED_CMD); //设置预充电周期
	OLED_WR_Byte(0xf1,OLED_CMD); //[3:0],PHASE 1;[7:4],PHASE 2;
	OLED_WR_Byte(0xDB,OLED_CMD); //设置VCOMH 电压倍率
	OLED_WR_Byte(0x30,OLED_CMD); //[6:4] 000,0.65*vcc;001,0.77*vcc;011,0.83*vcc;

	OLED_WR_Byte(0xA4,OLED_CMD); //全局显示开启;bit0:1,开启;0,关闭;(白屏/黑屏)
	OLED_WR_Byte(0xA6,OLED_CMD); //设置显示方式;bit0:1,反相显示;0,正常显示	    						   
	OLED_WR_Byte(0xAF,OLED_CMD); //开启显示	 
	OLED_Clear();
}  

```
## 串口一
```C
void uart_init(u32 pclk2,u32 bound)
{  	 
	float temp;
	u16 mantissa;
	u16 fraction;	   
	temp=(float)(pclk2*1000000)/(bound*16);//得到USARTDIV
	mantissa=temp;				 //得到整数部分
	fraction=(temp-mantissa)*16; //得到小数部分	 
    mantissa<<=4;
	mantissa+=fraction; 
	RCC->APB2ENR|=1<<2;   //使能PORTA口时钟  
	RCC->APB2ENR|=1<<14;  //使能串口时钟 
	GPIOA->CRH&=0XFFFFF00F;//IO状态设置
	GPIOA->CRH|=0X000008B0;//IO状态设置
		  
	RCC->APB2RSTR|=1<<14;   //复位串口1
	RCC->APB2RSTR&=~(1<<14);//停止复位	   	   
	//波特率设置
 	USART1->BRR=mantissa; // 波特率设置	 
	USART1->CR1|=0X200C;  //1位停止,无校验位.

}
```

## 串口三
```C
void uart3_init(u32 pclk2,u32 bound)
{  	 
	float temp;
	u16 mantissa;
	u16 fraction;	   
	temp=(float)(pclk2*1000000)/(bound*16);//得到USARTDIV
	mantissa=temp;				 //得到整数部分
	fraction=(temp-mantissa)*16; //得到小数部分	 
  mantissa<<=4;
	mantissa+=fraction; 
	RCC->APB2ENR|=1<<3;   //使能PORTB口时钟  
	RCC->APB1ENR|=1<<18;  //使能串口时钟 
	GPIOB->CRH&=0XFFFF00FF; 
	GPIOB->CRH|=0X00008B00;//IO状态设置
	GPIOB->ODR|=1<<10;	  
	RCC->APB1RSTR|=1<<18;   //复位串口1
	RCC->APB1RSTR&=~(1<<18);//停止复位	   	   
	//波特率设置
 	USART3->BRR=mantissa; // 波特率设置	 
	USART3->CR1|=0X200C;  //1位停止,无校验位.
	//使能接收中断
	USART3->CR1|=1<<8;    //PE中断使能
	USART3->CR1|=1<<5;    //接收缓冲区非空中断使能	    	
	MY_NVIC_Init(0,1,USART3_IRQn,2);//组2，最低优先级 
}
```
## PWM
```C
void MiniBalance_PWM_Init(u16 arr,u16 psc)
{		 					 
	MiniBalance_Motor_Init();  //初始化电机控制所需IO
	RCC->APB2ENR|=1<<11;       //使能TIM1时钟    
	RCC->APB2ENR|=1<<2;        //PORTA时钟使能     
	GPIOA->CRH&=0XFFFF0FF0;    //PORTA8 11复用输出
	GPIOA->CRH|=0X0000B00B;    //PORTA8 11复用输出
	TIM1->ARR=arr;             //设定计数器自动重装值 
	TIM1->PSC=psc;             //预分频器不分频
	TIM1->CCMR2|=6<<12;        //CH4 PWM1模式	
	TIM1->CCMR1|=6<<4;         //CH1 PWM1模式	
	TIM1->CCMR2|=1<<11;        //CH4预装载使能	 
	TIM1->CCMR1|=1<<3;         //CH1预装载使能	  
	TIM1->CCER|=1<<12;         //CH4输出使能	   
	TIM1->CCER|=1<<0;          //CH1输出使能	
	TIM1->BDTR |= 1<<15;       //TIM1必须要这句话才能输出PWM
	TIM1->CR1=0x8000;          //ARPE使能 
	TIM1->CR1|=0x01;          //使能定时器1 			
} 


```
## 编码器
```C
void Encoder_Init_TIM2(void)
{
	RCC->APB1ENR|=1<<0;     //TIM2时钟使能
	RCC->APB2ENR|=1<<2;    //使能PORTA时钟
	GPIOA->CRL&=0XFFFFFF00;//PA0 PA1
	GPIOA->CRL|=0X00000044;//浮空输入
	TIM2->DIER|=1<<0;   //允许更新中断				
	TIM2->DIER|=1<<6;   //允许触发中断
	MY_NVIC_Init(1,3,TIM2_IRQn,1);
	TIM2->PSC = 0x0;//预分频器
	TIM2->ARR = ENCODER_TIM_PERIOD;//设定计数器自动重装值 
	TIM2->CR1 &=~(3<<8);// 选择时钟分频：不分频
	TIM2->CR1 &=~(3<<5);// 选择计数模式:边沿对齐模式
		
	TIM2->CCMR1 |= 1<<0; //CC1S='01' IC1FP1映射到TI1
	TIM2->CCMR1 |= 1<<8; //CC2S='01' IC2FP2映射到TI2
	TIM2->CCER &= ~(1<<1);	 //CC1P='0'	 IC1FP1不反相，IC1FP1=TI1
	TIM2->CCER &= ~(1<<5);	 //CC2P='0'	 IC2FP2不反相，IC2FP2=TI2
	TIM2->CCMR1 |= 3<<4; //	IC1F='1000' 输入捕获1滤波器
	TIM2->SMCR |= 3<<0;	 //SMS='011' 所有的输入均在上升沿和下降沿有效
	TIM2->CR1 |= 0x01;    //CEN=1，使能定时器
}
```

## adc

```C
void  Adc_Init(void)
{    
  //先初始化IO口
 	RCC->APB2ENR|=1<<2;    //使能PORTA口时钟 
	GPIOA->CRL&=0XFFF0FFFF;//PA4 anolog输入 
	RCC->APB2ENR|=1<<9;    //ADC1时钟使能	  
	RCC->APB2RSTR|=1<<9;   //ADC1复位
	RCC->APB2RSTR&=~(1<<9);//复位结束	    
	RCC->CFGR&=~(3<<14);   //分频因子清零	
	//SYSCLK/DIV2=12M ADC时钟设置为12M,ADC最大时钟不能超过14M!
	//否则将导致ADC准确度下降! 
	RCC->CFGR|=2<<14;      	 
	ADC1->CR1&=0XF0FFFF;   //工作模式清零
	ADC1->CR1|=0<<16;      //独立工作模式  
	ADC1->CR1&=~(1<<8);    //非扫描模式	  
	ADC1->CR2&=~(1<<1);    //单次转换模式
	ADC1->CR2&=~(7<<17);	   
	ADC1->CR2|=7<<17;	   //软件控制转换  
	ADC1->CR2|=1<<20;      //使用用外部触发(SWSTART)!!!	必须使用一个事件来触发
	ADC1->CR2&=~(1<<11);   //右对齐	 
	ADC1->SQR1&=~(0XF<<20);
	ADC1->SQR1&=0<<20;     //1个转换在规则序列中 也就是只转换规则序列1 			   
	//设置通道4的采样时间
	ADC1->SMPR2&=0XFFF0FFFF; //采样时间清空	  
	ADC1->SMPR2|=7<<12;      // 239.5周期,提高采样时间可以提高精确度	 

	ADC1->CR2|=1<<0;	    //开启AD转换器	 
	ADC1->CR2|=1<<3;        //使能复位校准  
	while(ADC1->CR2&1<<3);  //等待校准结束 			 
    //该位由软件设置并由硬件清除。在校准寄存器被初始化后该位将被清除。 		 
	ADC1->CR2|=1<<2;        //开启AD校准	   
	while(ADC1->CR2&1<<2);  //等待校准结束 
}		
```

## IIC
```C
void IIC_Init(void)
{			
	RCC->APB2ENR|=1<<3;//先使能外设IO PORTB时钟 							 
	GPIOB->CRH&=0XFFFFFF00;//PB8/9 推挽输出 
	GPIOB->CRH|=0X00000033;	   
}
```

## MPU6050

```C
void MPU6050_initialize(void) {
    MPU6050_setClockSource(MPU6050_CLOCK_PLL_YGYRO); //设置时钟
    MPU6050_setFullScaleGyroRange(MPU6050_GYRO_FS_2000);//陀螺仪最大量程 +-1000度每秒
    MPU6050_setFullScaleAccelRange(MPU6050_ACCEL_FS_2);	//加速度度最大量程 +-2G
    MPU6050_setSleepEnabled(0); //进入工作状态
	 MPU6050_setI2CMasterModeEnabled(0);	 //不让MPU6050 控制AUXI2C
	 MPU6050_setI2CBypassEnabled(0);	 //主控制器的I2C与	MPU6050的AUXI2C	直通。控制器可以直接访问HMC5883L
}


```
## 6050内置DMP

```C
void DMP_Init(void)
{ 
   u8 temp[1]={0};
   i2cRead(0x68,0x75,1,temp);
	 Flag_Show=1;
	 printf("mpu_set_sensor complete ......\r\n");
	if(temp[0]!=0x68)NVIC_SystemReset();
	if(!mpu_init())
  {
	  if(!mpu_set_sensors(INV_XYZ_GYRO | INV_XYZ_ACCEL))
	  	 printf("mpu_set_sensor complete ......\r\n");
	  if(!mpu_configure_fifo(INV_XYZ_GYRO | INV_XYZ_ACCEL))
	  	 printf("mpu_configure_fifo complete ......\r\n");
	  if(!mpu_set_sample_rate(DEFAULT_MPU_HZ))
	  	 printf("mpu_set_sample_rate complete ......\r\n");
	  if(!dmp_load_motion_driver_firmware())
	  	printf("dmp_load_motion_driver_firmware complete ......\r\n");
	  if(!dmp_set_orientation(inv_orientation_matrix_to_scalar(gyro_orientation)))
	  	 printf("dmp_set_orientation complete ......\r\n");
	  if(!dmp_enable_feature(DMP_FEATURE_6X_LP_QUAT | DMP_FEATURE_TAP |
	        DMP_FEATURE_ANDROID_ORIENT | DMP_FEATURE_SEND_RAW_ACCEL | DMP_FEATURE_SEND_CAL_GYRO |
	        DMP_FEATURE_GYRO_CAL))
	  	 printf("dmp_enable_feature complete ......\r\n");
	  if(!dmp_set_fifo_rate(DEFAULT_MPU_HZ))
	  	 printf("dmp_set_fifo_rate complete ......\r\n");
	  run_self_test();
	  if(!mpu_set_dmp_state(1))
	  	 printf("mpu_set_dmp_state complete ......\r\n");
  }
	Flag_Show=0;
}
```


## 舵机
```C
void Servo_PWM_Init(u16 arr,u16 psc)	
{	 
	RCC->APB1ENR|=1<<2;     //TIM4时钟使能     
	RCC->APB2ENR|=1<<3;    	//使能PORTB时钟   	 
	GPIOB->CRL&=0XF0FFFFFF; 
	GPIOB->CRL|=0X0B000000;//  	PB.0 输入 PB.1输出
	TIM4->ARR=arr;             //设定计数器自动重装值 
	TIM4->PSC=psc;             //预分频器不分频
	TIM4->CCMR1|=6<<4;        //CH1 PWM1模式	
	TIM4->CCMR1|=1<<3;        //CH1预装载使能	   
	TIM4->CCER|=1<<0;         //CH1输出使能	   
	TIM4->CR1 = 0x80;           //ARPE使能 
	TIM4->CR1|=0x01;          //使能定时器1	
  TIM4->CCR1=750;	
}

```

## 中断
```C
void EXTI_Init(void)
{
	RCC->APB2ENR|=1<<3;    //使能PORTB时钟	   	 
	GPIOB->CRL&=0XFF0FFFFF; 
	GPIOB->CRL|=0X00800000;//PB5 上拉输入
  GPIOB->ODR|=1<<5; //PB5 上拉	
	Ex_NVIC_Config(GPIO_B,5,FTIR);		//下降沿触发
	MY_NVIC_Init(2,1,EXTI9_5_IRQn,2);  	//抢占2，子优先级1，组2
}


```

## 主任务循环

```C
	while(1)
		{     
			if(Flash_Send==1)        //写入PID参数到Flash,由app控制该指令
			{
				Flash_Write();	
				Flash_Send=0;	
			}	
          	if(Flag_Show==0)          //使用MiniBalance APP和OLED显示屏
			{
					APP_Show();	
					oled_show();          //===显示屏打开
			}
			else                      //使用MiniBalance上位机 上位机使用的时候需要严格的时序，故此时关闭app监控部分和OLED显示屏
			{
				DataScope();          //开启MiniBalance上位机
			}	
			delay_flag=1;	
			delay_50=0;
			while(delay_flag);	     //通过MPU6050的INT中断实现的50ms精准延时				
		} 
```
至此很容易发现并没有控制相关的代码，那是因为控制相关的代码都放在了定时器的中断服务函数里。

## 定时器中断服务函数
```C
int EXTI9_5_IRQHandler(void) 
{    
	 if(PBin(5)==0)		
	{   
		  EXTI->PR=1<<5;                                                      //清除LINE5上的中断标志位   
		   Flag_Target=!Flag_Target;                                          //通过任务标志位进行分频,实际10ms控制一次
		   if(delay_flag==1)
			 {
				 if(++delay_50==10)	 delay_50=0,delay_flag=0;                     //给主函数提供精准延时
			 }
		  if(Flag_Target==1)                                                  //5ms读取一次陀螺仪和加速度计的值，更高的采样频率可以改善卡尔曼滤波和互补滤波的效果
			{
				Get_Angle(Way_Angle);                                               //===更新姿态		
				if(++Flash_R_Count==150&&Angle_Balance>30)Flash_Read();             //=====读取Flash的PID参数		
				Voltage_Temp=Get_battery_volt();		                                //=====读取电池电压		
				Voltage_Count++;                                                    //=====平均值计数器
				Voltage_All+=Voltage_Temp;                                          //=====多次采样累积
				if(Voltage_Count==100) Voltage=Voltage_All/100,Voltage_All=0,Voltage_Count=0;//=====求平均值		
				Led_Flash(100);
			  return 0;	                                               
			 }                                                                   //10ms控制一次，为了保证M法测速的时间基准，首先读取编码器数据
			Encoder=-Read_Encoder(2);                                           //===读取编码器的值
	  	Get_Angle(Way_Angle);                                               //===更新姿态	
			Key();                                                              //===扫描按键状态 单击双击可以改变小车运行状态	 
			Balance_Pwm =balance(Angle_Balance,Gyro_Balance);                   //===平衡PID控制	 
			Servo_Pwm =servo(Balance_Pwm+Servo_Pwm);                  					//===舵机角度控制	  
			Velocity=-30-myabs(Balance_Pwm)/Balance_Kp;	                        //===速度控制 弯道加速
		  if(Velocity<-36)  Velocity=-36;	                                    //===速度限幅
		  if(Velocity>-30)  Velocity=-30;	 																		//===速度限幅
			Servo=MID+Balance_Pwm+Servo_Pwm;	                                  //===舵机控制
   		Xianfu_Pwm();                                                       //===PWM限幅 
			if(Servo<(MID-130)) Servo=MID-130;	                                //===舵机角度限制
		  if(Servo>(MID+130))  Servo=MID+130;	 																//===舵机角度限制
			 if(Put_Down(Angle_Balance,Encoder)==1)  Flag_Stop=0;               //===姿态识别启动
      if(Turn_Off(Angle_Balance,Voltage)==0)                              //===如果不存在异常
		  Motor=Incremental_PI_A(Encoder,Velocity),                  		//===计算左轮电机最终PWM	
 			Set_Pwm(-Motor);                                               //===赋值给PWM寄存器  
	}       	
	 return 0;	  
} 

```



















