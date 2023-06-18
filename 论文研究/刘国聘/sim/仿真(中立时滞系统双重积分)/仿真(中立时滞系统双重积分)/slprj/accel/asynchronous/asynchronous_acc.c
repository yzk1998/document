#include "asynchronous_acc.h"
#include "rtwtypes.h"
#include "asynchronous_acc_private.h"
#include "multiword_types.h"
#include <stdio.h>
#include "slexec_vm_simstruct_bridge.h"
#include "slexec_vm_zc_functions.h"
#include "slexec_vm_lookup_functions.h"
#include "slsv_diagnostic_codegen_c_api.h"
#include "simtarget/slSimTgtMdlrefSfcnBridge.h"
#include "simstruc.h"
#include "fixedpoint.h"
#define CodeFormat S-Function
#define AccDefine1 Accelerator_S-Function
#ifndef __RTW_UTFREE__  
extern void * utMalloc ( size_t ) ; extern void utFree ( void * ) ;
#endif
boolean_T asynchronous_acc_rt_TDelayUpdateTailOrGrowBuf ( int_T * bufSzPtr ,
int_T * tailPtr , int_T * headPtr , int_T * lastPtr , real_T tMinusDelay ,
real_T * * uBufPtr , boolean_T isfixedbuf , boolean_T istransportdelay ,
int_T * maxNewBufSzPtr ) { int_T testIdx ; int_T tail = * tailPtr ; int_T
bufSz = * bufSzPtr ; real_T * tBuf = * uBufPtr + bufSz ; real_T * xBuf = (
NULL ) ; int_T numBuffer = 2 ; if ( istransportdelay ) { numBuffer = 3 ; xBuf
= * uBufPtr + 2 * bufSz ; } testIdx = ( tail < ( bufSz - 1 ) ) ? ( tail + 1 )
: 0 ; if ( ( tMinusDelay <= tBuf [ testIdx ] ) && ! isfixedbuf ) { int_T j ;
real_T * tempT ; real_T * tempU ; real_T * tempX = ( NULL ) ; real_T * uBuf =
* uBufPtr ; int_T newBufSz = bufSz + 1024 ; if ( newBufSz > * maxNewBufSzPtr
) { * maxNewBufSzPtr = newBufSz ; } tempU = ( real_T * ) utMalloc ( numBuffer
* newBufSz * sizeof ( real_T ) ) ; if ( tempU == ( NULL ) ) { return ( false
) ; } tempT = tempU + newBufSz ; if ( istransportdelay ) tempX = tempT +
newBufSz ; for ( j = tail ; j < bufSz ; j ++ ) { tempT [ j - tail ] = tBuf [
j ] ; tempU [ j - tail ] = uBuf [ j ] ; if ( istransportdelay ) tempX [ j -
tail ] = xBuf [ j ] ; } for ( j = 0 ; j < tail ; j ++ ) { tempT [ j + bufSz -
tail ] = tBuf [ j ] ; tempU [ j + bufSz - tail ] = uBuf [ j ] ; if (
istransportdelay ) tempX [ j + bufSz - tail ] = xBuf [ j ] ; } if ( * lastPtr
> tail ) { * lastPtr -= tail ; } else { * lastPtr += ( bufSz - tail ) ; } *
tailPtr = 0 ; * headPtr = bufSz ; utFree ( uBuf ) ; * bufSzPtr = newBufSz ; *
uBufPtr = tempU ; } else { * tailPtr = testIdx ; } return ( true ) ; } real_T
asynchronous_acc_rt_TDelayInterpolate ( real_T tMinusDelay , real_T tStart ,
real_T * uBuf , int_T bufSz , int_T * lastIdx , int_T oldestIdx , int_T
newIdx , real_T initOutput , boolean_T discrete , boolean_T
minorStepAndTAtLastMajorOutput ) { int_T i ; real_T yout , t1 , t2 , u1 , u2
; real_T * tBuf = uBuf + bufSz ; if ( ( newIdx == 0 ) && ( oldestIdx == 0 )
&& ( tMinusDelay > tStart ) ) return initOutput ; if ( tMinusDelay <= tStart
) return initOutput ; if ( ( tMinusDelay <= tBuf [ oldestIdx ] ) ) { if (
discrete ) { return ( uBuf [ oldestIdx ] ) ; } else { int_T tempIdx =
oldestIdx + 1 ; if ( oldestIdx == bufSz - 1 ) tempIdx = 0 ; t1 = tBuf [
oldestIdx ] ; t2 = tBuf [ tempIdx ] ; u1 = uBuf [ oldestIdx ] ; u2 = uBuf [
tempIdx ] ; if ( t2 == t1 ) { if ( tMinusDelay >= t2 ) { yout = u2 ; } else {
yout = u1 ; } } else { real_T f1 = ( t2 - tMinusDelay ) / ( t2 - t1 ) ;
real_T f2 = 1.0 - f1 ; yout = f1 * u1 + f2 * u2 ; } return yout ; } } if (
minorStepAndTAtLastMajorOutput ) { if ( newIdx != 0 ) { if ( * lastIdx ==
newIdx ) { ( * lastIdx ) -- ; } newIdx -- ; } else { if ( * lastIdx == newIdx
) { * lastIdx = bufSz - 1 ; } newIdx = bufSz - 1 ; } } i = * lastIdx ; if (
tBuf [ i ] < tMinusDelay ) { while ( tBuf [ i ] < tMinusDelay ) { if ( i ==
newIdx ) break ; i = ( i < ( bufSz - 1 ) ) ? ( i + 1 ) : 0 ; } } else { while
( tBuf [ i ] >= tMinusDelay ) { i = ( i > 0 ) ? i - 1 : ( bufSz - 1 ) ; } i =
( i < ( bufSz - 1 ) ) ? ( i + 1 ) : 0 ; } * lastIdx = i ; if ( discrete ) {
double tempEps = ( DBL_EPSILON ) * 128.0 ; double localEps = tempEps *
muDoubleScalarAbs ( tBuf [ i ] ) ; if ( tempEps > localEps ) { localEps =
tempEps ; } localEps = localEps / 2.0 ; if ( tMinusDelay >= ( tBuf [ i ] -
localEps ) ) { yout = uBuf [ i ] ; } else { if ( i == 0 ) { yout = uBuf [
bufSz - 1 ] ; } else { yout = uBuf [ i - 1 ] ; } } } else { if ( i == 0 ) {
t1 = tBuf [ bufSz - 1 ] ; u1 = uBuf [ bufSz - 1 ] ; } else { t1 = tBuf [ i -
1 ] ; u1 = uBuf [ i - 1 ] ; } t2 = tBuf [ i ] ; u2 = uBuf [ i ] ; if ( t2 ==
t1 ) { if ( tMinusDelay >= t2 ) { yout = u2 ; } else { yout = u1 ; } } else {
real_T f1 = ( t2 - tMinusDelay ) / ( t2 - t1 ) ; real_T f2 = 1.0 - f1 ; yout
= f1 * u1 + f2 * u2 ; } } return ( yout ) ; } void rt_ssGetBlockPath (
SimStruct * S , int_T sysIdx , int_T blkIdx , char_T * * path ) {
_ssGetBlockPath ( S , sysIdx , blkIdx , path ) ; } void rt_ssSet_slErrMsg (
void * S , void * diag ) { SimStruct * castedS = ( SimStruct * ) S ; if ( !
_ssIsErrorStatusAslErrMsg ( castedS ) ) { _ssSet_slErrMsg ( castedS , diag )
; } else { _ssDiscardDiagnostic ( castedS , diag ) ; } } void
rt_ssReportDiagnosticAsWarning ( void * S , void * diag ) {
_ssReportDiagnosticAsWarning ( ( SimStruct * ) S , diag ) ; } void
rt_ssReportDiagnosticAsInfo ( void * S , void * diag ) {
_ssReportDiagnosticAsInfo ( ( SimStruct * ) S , diag ) ; } static void
mdlOutputs ( SimStruct * S , int_T tid ) { B_asynchronous_T * _rtB ;
DW_asynchronous_T * _rtDW ; P_asynchronous_T * _rtP ; real_T ( * lastU ) [ 2
] ; real_T lastTime ; int32_T isHit ; _rtDW = ( ( DW_asynchronous_T * )
ssGetRootDWork ( S ) ) ; _rtP = ( ( P_asynchronous_T * ) ssGetModelRtp ( S )
) ; _rtB = ( ( B_asynchronous_T * ) _ssGetModelBlockIO ( S ) ) ; { real_T * *
uBuffer = ( real_T * * ) & _rtDW -> TransportDelay_PWORK . TUbufferPtrs [ 0 ]
; real_T simTime = ssGetT ( S ) ; real_T tMinusDelay ; { int_T i1 ; real_T *
y0 = & _rtB -> B_0_0_0 [ 0 ] ; int_T * iw_Tail = & _rtDW ->
TransportDelay_IWORK . Tail [ 0 ] ; int_T * iw_Head = & _rtDW ->
TransportDelay_IWORK . Head [ 0 ] ; int_T * iw_Last = & _rtDW ->
TransportDelay_IWORK . Last [ 0 ] ; int_T * iw_CircularBufSize = & _rtDW ->
TransportDelay_IWORK . CircularBufSize [ 0 ] ; for ( i1 = 0 ; i1 < 2 ; i1 ++
) { tMinusDelay = ( ( _rtP -> P_0 > 0.0 ) ? _rtP -> P_0 : 0.0 ) ; tMinusDelay
= simTime - tMinusDelay ; y0 [ i1 ] = asynchronous_acc_rt_TDelayInterpolate (
tMinusDelay , 0.0 , * uBuffer , iw_CircularBufSize [ i1 ] , & iw_Last [ i1 ]
, iw_Tail [ i1 ] , iw_Head [ i1 ] , _rtP -> P_1 , 0 , ( boolean_T ) (
ssIsMinorTimeStep ( S ) && ( ( * uBuffer + iw_CircularBufSize [ i1 ] ) [
iw_Head [ i1 ] ] == ssGetT ( S ) ) ) ) ; uBuffer ++ ; } } } isHit =
ssIsSampleHit ( S , 1 , 0 ) ; if ( isHit != 0 ) { ssCallAccelRunBlock ( S , 0
, 1 , SS_CALL_MDL_OUTPUTS ) ; } { real_T * * uBuffer = ( real_T * * ) & _rtDW
-> TransportDelay1_PWORK . TUbufferPtrs [ 0 ] ; real_T simTime = ssGetT ( S )
; real_T tMinusDelay ; { int_T i1 ; real_T * y0 = & _rtB -> B_0_2_0 [ 0 ] ;
int_T * iw_Tail = & _rtDW -> TransportDelay1_IWORK . Tail [ 0 ] ; int_T *
iw_Head = & _rtDW -> TransportDelay1_IWORK . Head [ 0 ] ; int_T * iw_Last = &
_rtDW -> TransportDelay1_IWORK . Last [ 0 ] ; int_T * iw_CircularBufSize = &
_rtDW -> TransportDelay1_IWORK . CircularBufSize [ 0 ] ; for ( i1 = 0 ; i1 <
2 ; i1 ++ ) { tMinusDelay = ( ( _rtP -> P_2 > 0.0 ) ? _rtP -> P_2 : 0.0 ) ;
tMinusDelay = simTime - tMinusDelay ; y0 [ i1 ] =
asynchronous_acc_rt_TDelayInterpolate ( tMinusDelay , 0.0 , * uBuffer ,
iw_CircularBufSize [ i1 ] , & iw_Last [ i1 ] , iw_Tail [ i1 ] , iw_Head [ i1
] , _rtP -> P_3 , 0 , ( boolean_T ) ( ssIsMinorTimeStep ( S ) && ( ( *
uBuffer + iw_CircularBufSize [ i1 ] ) [ iw_Head [ i1 ] ] == ssGetT ( S ) ) )
) ; uBuffer ++ ; } } } if ( ( _rtDW -> TimeStampA >= ssGetT ( S ) ) && (
_rtDW -> TimeStampB >= ssGetT ( S ) ) ) { _rtB -> B_0_3_0 [ 0 ] = 0.0 ; _rtB
-> B_0_3_0 [ 1 ] = 0.0 ; } else { lastTime = _rtDW -> TimeStampA ; lastU = &
_rtDW -> LastUAtTimeA ; if ( _rtDW -> TimeStampA < _rtDW -> TimeStampB ) { if
( _rtDW -> TimeStampB < ssGetT ( S ) ) { lastTime = _rtDW -> TimeStampB ;
lastU = & _rtDW -> LastUAtTimeB ; } } else if ( _rtDW -> TimeStampA >= ssGetT
( S ) ) { lastTime = _rtDW -> TimeStampB ; lastU = & _rtDW -> LastUAtTimeB ;
} lastTime = ssGetT ( S ) - lastTime ; _rtB -> B_0_3_0 [ 0 ] = ( _rtB ->
B_0_2_0 [ 0 ] - ( * lastU ) [ 0 ] ) / lastTime ; _rtB -> B_0_3_0 [ 1 ] = (
_rtB -> B_0_2_0 [ 1 ] - ( * lastU ) [ 1 ] ) / lastTime ; } _rtB -> B_0_4_0 [
0 ] = _rtB -> B_0_0_0 [ 0 ] ; _rtB -> B_0_4_0 [ 2 ] = _rtB -> B_0_3_0 [ 0 ] ;
_rtB -> B_0_4_0 [ 1 ] = _rtB -> B_0_0_0 [ 1 ] ; _rtB -> B_0_4_0 [ 3 ] = _rtB
-> B_0_3_0 [ 1 ] ; ssCallAccelRunBlock ( S , 0 , 5 , SS_CALL_MDL_OUTPUTS ) ;
isHit = ssIsSampleHit ( S , 1 , 0 ) ; if ( isHit != 0 ) { ssCallAccelRunBlock
( S , 0 , 6 , SS_CALL_MDL_OUTPUTS ) ; ssCallAccelRunBlock ( S , 0 , 7 ,
SS_CALL_MDL_OUTPUTS ) ; ssCallAccelRunBlock ( S , 0 , 8 , SS_CALL_MDL_OUTPUTS
) ; ssCallAccelRunBlock ( S , 0 , 9 , SS_CALL_MDL_OUTPUTS ) ; }
UNUSED_PARAMETER ( tid ) ; }
#define MDL_UPDATE
static void mdlUpdate ( SimStruct * S , int_T tid ) { B_asynchronous_T * _rtB
; DW_asynchronous_T * _rtDW ; P_asynchronous_T * _rtP ; real_T ( * lastU ) [
2 ] ; _rtDW = ( ( DW_asynchronous_T * ) ssGetRootDWork ( S ) ) ; _rtP = ( (
P_asynchronous_T * ) ssGetModelRtp ( S ) ) ; _rtB = ( ( B_asynchronous_T * )
_ssGetModelBlockIO ( S ) ) ; { real_T * * uBuffer = ( real_T * * ) & _rtDW ->
TransportDelay_PWORK . TUbufferPtrs [ 0 ] ; real_T simTime = ssGetT ( S ) ;
_rtDW -> TransportDelay_IWORK . Head [ 0 ] = ( ( _rtDW ->
TransportDelay_IWORK . Head [ 0 ] < ( _rtDW -> TransportDelay_IWORK .
CircularBufSize [ 0 ] - 1 ) ) ? ( _rtDW -> TransportDelay_IWORK . Head [ 0 ]
+ 1 ) : 0 ) ; if ( _rtDW -> TransportDelay_IWORK . Head [ 0 ] == _rtDW ->
TransportDelay_IWORK . Tail [ 0 ] ) { if ( !
asynchronous_acc_rt_TDelayUpdateTailOrGrowBuf ( & _rtDW ->
TransportDelay_IWORK . CircularBufSize [ 0 ] , & _rtDW ->
TransportDelay_IWORK . Tail [ 0 ] , & _rtDW -> TransportDelay_IWORK . Head [
0 ] , & _rtDW -> TransportDelay_IWORK . Last [ 0 ] , simTime - _rtP -> P_0 ,
uBuffer , ( boolean_T ) 0 , false , & _rtDW -> TransportDelay_IWORK .
MaxNewBufSize ) ) { ssSetErrorStatus ( S , "tdelay memory allocation error" )
; return ; } } ( * uBuffer + _rtDW -> TransportDelay_IWORK . CircularBufSize
[ 0 ] ) [ _rtDW -> TransportDelay_IWORK . Head [ 0 ] ] = simTime ; ( *
uBuffer ++ ) [ _rtDW -> TransportDelay_IWORK . Head [ 0 ] ] = _rtB -> B_0_5_0
[ 0 ] ; _rtDW -> TransportDelay_IWORK . Head [ 1 ] = ( ( _rtDW ->
TransportDelay_IWORK . Head [ 1 ] < ( _rtDW -> TransportDelay_IWORK .
CircularBufSize [ 1 ] - 1 ) ) ? ( _rtDW -> TransportDelay_IWORK . Head [ 1 ]
+ 1 ) : 0 ) ; if ( _rtDW -> TransportDelay_IWORK . Head [ 1 ] == _rtDW ->
TransportDelay_IWORK . Tail [ 1 ] ) { if ( !
asynchronous_acc_rt_TDelayUpdateTailOrGrowBuf ( & _rtDW ->
TransportDelay_IWORK . CircularBufSize [ 1 ] , & _rtDW ->
TransportDelay_IWORK . Tail [ 1 ] , & _rtDW -> TransportDelay_IWORK . Head [
1 ] , & _rtDW -> TransportDelay_IWORK . Last [ 1 ] , simTime - _rtP -> P_0 ,
uBuffer , ( boolean_T ) 0 , false , & _rtDW -> TransportDelay_IWORK .
MaxNewBufSize ) ) { ssSetErrorStatus ( S , "tdelay memory allocation error" )
; return ; } } ( * uBuffer + _rtDW -> TransportDelay_IWORK . CircularBufSize
[ 1 ] ) [ _rtDW -> TransportDelay_IWORK . Head [ 1 ] ] = simTime ; ( *
uBuffer ) [ _rtDW -> TransportDelay_IWORK . Head [ 1 ] ] = _rtB -> B_0_5_0 [
1 ] ; } { real_T * * uBuffer = ( real_T * * ) & _rtDW ->
TransportDelay1_PWORK . TUbufferPtrs [ 0 ] ; real_T simTime = ssGetT ( S ) ;
_rtDW -> TransportDelay1_IWORK . Head [ 0 ] = ( ( _rtDW ->
TransportDelay1_IWORK . Head [ 0 ] < ( _rtDW -> TransportDelay1_IWORK .
CircularBufSize [ 0 ] - 1 ) ) ? ( _rtDW -> TransportDelay1_IWORK . Head [ 0 ]
+ 1 ) : 0 ) ; if ( _rtDW -> TransportDelay1_IWORK . Head [ 0 ] == _rtDW ->
TransportDelay1_IWORK . Tail [ 0 ] ) { if ( !
asynchronous_acc_rt_TDelayUpdateTailOrGrowBuf ( & _rtDW ->
TransportDelay1_IWORK . CircularBufSize [ 0 ] , & _rtDW ->
TransportDelay1_IWORK . Tail [ 0 ] , & _rtDW -> TransportDelay1_IWORK . Head
[ 0 ] , & _rtDW -> TransportDelay1_IWORK . Last [ 0 ] , simTime - _rtP -> P_2
, uBuffer , ( boolean_T ) 0 , false , & _rtDW -> TransportDelay1_IWORK .
MaxNewBufSize ) ) { ssSetErrorStatus ( S , "tdelay memory allocation error" )
; return ; } } ( * uBuffer + _rtDW -> TransportDelay1_IWORK . CircularBufSize
[ 0 ] ) [ _rtDW -> TransportDelay1_IWORK . Head [ 0 ] ] = simTime ; ( *
uBuffer ++ ) [ _rtDW -> TransportDelay1_IWORK . Head [ 0 ] ] = _rtB ->
B_0_5_0 [ 0 ] ; _rtDW -> TransportDelay1_IWORK . Head [ 1 ] = ( ( _rtDW ->
TransportDelay1_IWORK . Head [ 1 ] < ( _rtDW -> TransportDelay1_IWORK .
CircularBufSize [ 1 ] - 1 ) ) ? ( _rtDW -> TransportDelay1_IWORK . Head [ 1 ]
+ 1 ) : 0 ) ; if ( _rtDW -> TransportDelay1_IWORK . Head [ 1 ] == _rtDW ->
TransportDelay1_IWORK . Tail [ 1 ] ) { if ( !
asynchronous_acc_rt_TDelayUpdateTailOrGrowBuf ( & _rtDW ->
TransportDelay1_IWORK . CircularBufSize [ 1 ] , & _rtDW ->
TransportDelay1_IWORK . Tail [ 1 ] , & _rtDW -> TransportDelay1_IWORK . Head
[ 1 ] , & _rtDW -> TransportDelay1_IWORK . Last [ 1 ] , simTime - _rtP -> P_2
, uBuffer , ( boolean_T ) 0 , false , & _rtDW -> TransportDelay1_IWORK .
MaxNewBufSize ) ) { ssSetErrorStatus ( S , "tdelay memory allocation error" )
; return ; } } ( * uBuffer + _rtDW -> TransportDelay1_IWORK . CircularBufSize
[ 1 ] ) [ _rtDW -> TransportDelay1_IWORK . Head [ 1 ] ] = simTime ; ( *
uBuffer ) [ _rtDW -> TransportDelay1_IWORK . Head [ 1 ] ] = _rtB -> B_0_5_0 [
1 ] ; } if ( _rtDW -> TimeStampA == ( rtInf ) ) { _rtDW -> TimeStampA =
ssGetT ( S ) ; lastU = & _rtDW -> LastUAtTimeA ; } else if ( _rtDW ->
TimeStampB == ( rtInf ) ) { _rtDW -> TimeStampB = ssGetT ( S ) ; lastU = &
_rtDW -> LastUAtTimeB ; } else if ( _rtDW -> TimeStampA < _rtDW -> TimeStampB
) { _rtDW -> TimeStampA = ssGetT ( S ) ; lastU = & _rtDW -> LastUAtTimeA ; }
else { _rtDW -> TimeStampB = ssGetT ( S ) ; lastU = & _rtDW -> LastUAtTimeB ;
} ( * lastU ) [ 0 ] = _rtB -> B_0_2_0 [ 0 ] ; ( * lastU ) [ 1 ] = _rtB ->
B_0_2_0 [ 1 ] ; ssCallAccelRunBlock ( S , 0 , 5 , SS_CALL_MDL_UPDATE ) ;
UNUSED_PARAMETER ( tid ) ; }
#define MDL_DERIVATIVES
static void mdlDerivatives ( SimStruct * S ) { B_asynchronous_T * _rtB ; _rtB
= ( ( B_asynchronous_T * ) _ssGetModelBlockIO ( S ) ) ; ssCallAccelRunBlock (
S , 0 , 5 , SS_CALL_MDL_DERIVATIVES ) ; } static void mdlInitializeSizes (
SimStruct * S ) { ssSetChecksumVal ( S , 0 , 3827591815U ) ; ssSetChecksumVal
( S , 1 , 2777620481U ) ; ssSetChecksumVal ( S , 2 , 4123209256U ) ;
ssSetChecksumVal ( S , 3 , 2173762415U ) ; { mxArray * slVerStructMat = (
NULL ) ; mxArray * slStrMat = mxCreateString ( "simulink" ) ; char slVerChar
[ 10 ] ; int status = mexCallMATLAB ( 1 , & slVerStructMat , 1 , & slStrMat ,
"ver" ) ; if ( status == 0 ) { mxArray * slVerMat = mxGetField (
slVerStructMat , 0 , "Version" ) ; if ( slVerMat == ( NULL ) ) { status = 1 ;
} else { status = mxGetString ( slVerMat , slVerChar , 10 ) ; } }
mxDestroyArray ( slStrMat ) ; mxDestroyArray ( slVerStructMat ) ; if ( (
status == 1 ) || ( strcmp ( slVerChar , "10.5" ) != 0 ) ) { return ; } }
ssSetOptions ( S , SS_OPTION_EXCEPTION_FREE_CODE ) ; if ( ssGetSizeofDWork (
S ) != sizeof ( DW_asynchronous_T ) ) { ssSetErrorStatus ( S ,
"Unexpected error: Internal DWork sizes do "
"not match for accelerator mex file." ) ; } if ( ssGetSizeofGlobalBlockIO ( S
) != sizeof ( B_asynchronous_T ) ) { ssSetErrorStatus ( S ,
"Unexpected error: Internal BlockIO sizes do "
"not match for accelerator mex file." ) ; } { int ssSizeofParams ;
ssGetSizeofParams ( S , & ssSizeofParams ) ; if ( ssSizeofParams != sizeof (
P_asynchronous_T ) ) { static char msg [ 256 ] ; sprintf ( msg ,
"Unexpected error: Internal Parameters sizes do "
"not match for accelerator mex file." ) ; } } _ssSetModelRtp ( S , ( real_T *
) & asynchronous_rtDefaultP ) ; rt_InitInfAndNaN ( sizeof ( real_T ) ) ; }
static void mdlInitializeSampleTimes ( SimStruct * S ) { } static void
mdlTerminate ( SimStruct * S ) { }
#include "simulink.c"
