#ifndef RTW_HEADER_asynchronous_acc_h_
#define RTW_HEADER_asynchronous_acc_h_
#ifndef asynchronous_acc_COMMON_INCLUDES_
#define asynchronous_acc_COMMON_INCLUDES_
#include <stdlib.h>
#define S_FUNCTION_NAME simulink_only_sfcn
#define S_FUNCTION_LEVEL 2
#ifndef RTW_GENERATED_S_FUNCTION
#define RTW_GENERATED_S_FUNCTION
#endif
#include "rtwtypes.h"
#include "simstruc.h"
#include "fixedpoint.h"
#endif
#include "asynchronous_acc_types.h"
#include <stddef.h>
#include "rtGetInf.h"
#include "rt_nonfinite.h"
#include <float.h>
#include "mwmathutil.h"
#include "rt_defines.h"
typedef struct { real_T B_0_0_0 [ 2 ] ; real_T B_0_2_0 [ 2 ] ; real_T B_0_3_0
[ 2 ] ; real_T B_0_4_0 [ 4 ] ; real_T B_0_5_0 [ 6 ] ; } B_asynchronous_T ;
typedef struct { real_T TimeStampA ; real_T LastUAtTimeA [ 2 ] ; real_T
TimeStampB ; real_T LastUAtTimeB [ 2 ] ; struct { real_T modelTStart ; }
TransportDelay_RWORK ; struct { real_T modelTStart ; } TransportDelay1_RWORK
; struct { void * TUbufferPtrs [ 4 ] ; } TransportDelay_PWORK ; void *
Scope1_PWORK ; struct { void * TUbufferPtrs [ 4 ] ; } TransportDelay1_PWORK ;
void * Scope2_PWORK ; void * Scope3_PWORK ; void * Scope4_PWORK ; void *
Scope5_PWORK ; struct { int_T Tail [ 2 ] ; int_T Head [ 2 ] ; int_T Last [ 2
] ; int_T CircularBufSize [ 2 ] ; int_T MaxNewBufSize ; }
TransportDelay_IWORK ; struct { int_T Tail [ 2 ] ; int_T Head [ 2 ] ; int_T
Last [ 2 ] ; int_T CircularBufSize [ 2 ] ; int_T MaxNewBufSize ; }
TransportDelay1_IWORK ; } DW_asynchronous_T ; typedef struct { real_T
SFunction_CSTATE [ 2 ] ; } X_asynchronous_T ; typedef struct { real_T
SFunction_CSTATE [ 2 ] ; } XDot_asynchronous_T ; typedef struct { boolean_T
SFunction_CSTATE [ 2 ] ; } XDis_asynchronous_T ; struct P_asynchronous_T_ {
real_T P_0 ; real_T P_1 ; real_T P_2 ; real_T P_3 ; } ; extern
P_asynchronous_T asynchronous_rtDefaultP ;
#endif
