COUNTER0 EQU 0600H
COUNTER1 EQU 0602H 
COUNTER2 EQU 0604H 
CON8254 EQU 0606H      

A8255 EQU 0640H
B8255 EQU 0642H
C8255 EQU 0644H
CON8255 EQU 0646H
DATA SEGMENT
    LASTNUMBER DB 0
DATA ENDS

CODE SEGMENT
          ASSUME CS:CODE
    START:
          MOV    DX,CON8255
          MOV    AL,80H            ;A--OUT,B--OUT
          OUT    DX,AL
    
    ;设置中断向量  MIR6
          MOV    AX,OFFSET MIR6    ;存偏移量
          MOV    SI,38H
          MOV    [SI],AX
          MOV    AX,CS             ;存段地址
          MOV    SI,3AH
          MOV    [SI],AX
          CLI                      ;关中断
    ;设置ICW1~ICW4和OCW1
          MOV    AL,11H
          OUT    20H,AL
          MOV    AL,08H            ;中断源选择IR0
          OUT    21H,AL
          MOV    AL,04H            ;S2为1表示有内部从片被级联到主片的IR2上
          OUT    21H,AL
          MOV    AL,07H            ;D2为1表示其为主片，D1为1表示为自动中断，D0为1表示为8086~Pentinum的CPU
          OUT    21H,AL
          MOV    AL,2FH            ;M7和M6为0表示IR7和IR6,IR4（用于复位）三个个中断未被屏蔽，其它中断均被屏蔽
          OUT    21H,AL
          STI                      ;开中断
    
          MOV    DX,CON8254
          MOV    AL,76H            ;计数器1工作在方式3
          OUT    DX,AL
          MOV    DX,COUNTER1
          MOV    AL,00H
          OUT    DX,AL
          MOV    AL,48H
          OUT    DX,AL             ;计数初值4800H，选用时钟18.432KHZ
    
    
          MOV    AL,00H
          MOV    DX,B8255
    MAIN: 
          OUT    DX,AL
          JMP    MAIN
    
    MIR6: 
          CMP    AL,0FFH
          JZ     I1
          ROL    AL,1
          INC    AL
          JMP    I2
    I1:   
          MOV    AL,00H
    I2:   
          IRET
  

CODE ENDS
    END START
