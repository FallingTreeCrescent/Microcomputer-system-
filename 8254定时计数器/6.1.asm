CONUTER0 EQU 0600H
CONUTER1 EQU 0602H 
CONUTER2 EQU 0604H 
CON8254 EQU 0606H    

CODE SEGMENT
          ASSUME CS:CODE
    START:
          MOV    DX, CON8254
    ;MOV AL,70H  ;计数器1工作在方式0
    ;MOV AL,72H  ;方式1
          MOV    AL,74H          ;方式2
    ;MOV AL, 76H  ;方式3
          OUT    DX, AL
          MOV    DX, CONUTER1
          MOV    AL, 00H
          OUT    DX, AL
          MOV    AL, 48H
          OUT    DX, AL
    AA1:  
          JMP    AA1
    ;将GATE1置为高电平，运行程序，在示波器中可以看到OUT1输出一段高电平后会输出一个宽度为一个周期的负脉冲。
CODE ENDS
    END START
