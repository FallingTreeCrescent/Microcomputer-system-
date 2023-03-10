A8255 EQU 0600H
B8255 EQU 0602H
C8255 EQU 0604H
CON8255 EQU 0606H  
;0809使用IOY1片选信号
A0809 EQU 0640H
B0809 EQU 0642H

CODE SEGMENT
    ASSUME CS:CODE
START:	  
    MOV DX, CON8255  
    MOV AL, 90H      ;A--IN,B--OUT
    OUT DX, AL
 
X3: 
	MOV DX,B0809
    MOV AL,01H
    OUT DX,AL      ;启动1通道	
    MOV DX, A0809  
    OUT DX, AL     ;启动AD采样
X1: 
    MOV DX,A8255
    IN AL,DX       ;从8255A口读入EOC状态
    TEST AL,80H    ;如果是不是高电平，表示未完成转换
    JNZ X1         
X2:
    MOV DX,A8255
    IN AL,DX       ;从8255A口读入EOC状态   
    TEST AL,80H    
    JZ X2          ;如果是高电平，表示装换未完成
 
    MOV DX,A0809
    IN AL,DX       ;从ADC0809读入转换完成的数据
    MOV DX, B8255
    OUT DX,AL      ;从8255B口输出转换完成的数据
    JMP X3         ;循环转换
CODE ENDS 
    END START
