@echo off
set MATLAB=D:\matlab
"%MATLAB%\bin\win64\gmake" -f asynchronous.mk  OPTS="-DTID01EQ=1"
