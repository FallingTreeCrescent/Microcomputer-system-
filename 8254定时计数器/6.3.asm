A8254 EQU 0600H
B8254 EQU 0602H 
C8254 EQU 0604H 
CON8254 EQU 0606H                     

CODE SEGMENT
          ASSUME CS:CODE
    START:
 
          MOV    DX, CON8254
          MOV    AL, 76H        ;8254计数器1工作在方式3，产生方波信号
          OUT    DX, AL
          MOV    DX, B8254
          MOV    AL, 00H
          OUT    DX, AL
          MOV    AL, 48H        ;写入计数初值4800H，接18.432KHZ时钟源，这样方波周期则为1s
          OUT    DX, AL
    AA1:  
          JMP    AA1
CODE ENDS
    END START
