P8255A EQU 0640H
P8255B EQU 0642H
P8255C EQU 0646H
P8255MODE EQU 0646H
SSTACK	SEGMENT STACK
		DW 32 DUP(0)
SSTACK	ENDS
 
CODE   	SEGMENT
	   	ASSUME CS:CODE
 
START: 	MOV DX,P8255MODE
		MOV AL,10010000B
		OUT DX,AL				;送方式控制字
NEXT:
		MOV AL,080H				;初始时D7点亮，其余灯熄灭
		MOV	DX,P8255B
		OUT DX,AL				;送b口
		
		MOV BX,02H				;BX是标志 02H代表停止移动
		
		PUSH DS
		MOV AX, 0000H
		MOV DS, AX
		MOV AX, OFFSET MIR7		;取中断入口地址
		MOV SI, 003CH			;中断矢量地址
		MOV [SI], AX			;填IRQ7的偏移矢量
		MOV AX, CS				;段地址
		MOV SI, 003EH
		MOV [SI], AX			;填IRQ7的段地址矢量		
		MOV AX, OFFSET MIR6	
		MOV SI, 0038H
		MOV [SI], AX
		MOV AX, CS
		MOV SI, 003AH
		MOV [SI], AX
		CLI
		POP DS
		;初始化主片8259
		MOV AL, 11H				;级联，边沿触发，要ICW4
		OUT 20H, AL				;ICW1
		MOV AL, 08H				;中断类型号从8开始
		OUT 21H, AL				;ICW2
		MOV AL, 04H				; 
		OUT 21H, AL				;ICW3
		MOV AL, 01H				;非缓冲方式，8086/8088配置
		OUT 21H, AL				;ICW4
 
		;初始化从片8259
		MOV AL, 11H				;级联，边沿触发，要ICW4
		OUT 0A0H, AL			;ICW1
		MOV AL, 30H				;中断类型号从30H开始
		OUT 0A1H, AL			;ICW2
		MOV AL, 02H				;通过IR1引脚连接主片
		OUT 0A1H, AL			;ICW3
		MOV AL, 01H				;非缓冲方式，8086/8088配置
		OUT 0A1H, AL			;ICW4
		MOV AL, 0FDH
		OUT 0A1H,AL				;从8259 OCW1 = 1111 1101	允许IR1中断请求	
		MOV AL, 2BH       		;0010 1011
		OUT 21H, AL				;主8259 OCW1	不屏蔽IR2 IR4 IR6 IR7
		STI
 		
AA2:	NOP
		CMP BX,01H				;01H代表向右移动
		JZ	AA3
		CMP BX,00H				;00H代表向左移动
		JZ  AA4
		JMP AA2
		
AA3:
		MOV DX, 0642H
		IN AL,DX				;从b口读入状态
  
		CMP AL,01H				;到达了最右侧
		JZ AA5					
    
		ROR AL,1				;循环右移
		CALL DELAY
		OUT DX,AL				;送b口
		JMP AA2    
AA5: 	MOV BX,02H				;标志置停止
		JMP AA2
		
AA4:
		MOV DX, 0642H			;从b口读入状态
		IN AL,DX
    
		CMP AL,80H				;到达了最左侧
		JZ AA6
    
		ROL AL,1				;循环左移
		CALL DELAY
		OUT DX,AL				;送b口
		JMP AA2    
AA6:	MOV BX,02H				;标志置停止
		JMP AA2
 
MIR7:	
		MOV BX,00H				;标志置左移
		PUSH AX					;保护AX
		MOV AL, 20H
		OUT 20H, AL
		POP AX
		IRET
MIR6:	
		MOV BX,01H				;标志置右移
		PUSH AX					;保护AX
		MOV AL, 20H
		OUT 20H, AL
		POP AX
		IRET

DELAY:	PUSH CX					;延时子程序
		MOV AL, 04H
AA1:	MOV CX, 0FFFFH 
AA0:	PUSH AX
		POP  AX
		LOOP AA0
		SUB AL,1
		JNZ AA1
		POP CX
		RET
		
CODE	ENDS
		END  START