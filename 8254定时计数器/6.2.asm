A8254 EQU 0600H
B8254 EQU 0602H 
C8254 EQU 0604H 
CON8254 EQU 0606H                     

CODE SEGMENT
          ASSUME CS:CODE
    START:
 
          MOV    DX, CON8254
          MOV    AL, 70H        ;8254计数器1工作在方式0，计数时输出低电平，到0时输出高电平
          OUT    DX, AL
          MOV    DX, B8254
          MOV    AL, 00H
          OUT    DX, AL
          MOV    AL, 48H        ;写入计数初值4800H，接18.432KHZ时钟源，这样可到达计时1s后输出正跃变信号
          OUT    DX, AL
    AA1:  
          JMP    AA1
    ;将GATE1置为低电平，运行程序。
    ;将GATE1置为高电平，在示波器中可以观察到OUT1输出低电平，待过一段时间后（计数器减至0）输出高电平。
CODE ENDS
    END START
