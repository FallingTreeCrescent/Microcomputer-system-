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
		OUT DX,AL				;�ͷ�ʽ������
NEXT:
		MOV AL,080H				;��ʼʱD7�����������Ϩ��
		MOV	DX,P8255B
		OUT DX,AL				;��b��
		
		MOV BX,02H				;BX�Ǳ�־ 02H����ֹͣ�ƶ�
		
		PUSH DS
		MOV AX, 0000H
		MOV DS, AX
		MOV AX, OFFSET MIR7		;ȡ�ж���ڵ�ַ
		MOV SI, 003CH			;�ж�ʸ����ַ
		MOV [SI], AX			;��IRQ7��ƫ��ʸ��
		MOV AX, CS				;�ε�ַ
		MOV SI, 003EH
		MOV [SI], AX			;��IRQ7�Ķε�ַʸ��		
		MOV AX, OFFSET MIR6	
		MOV SI, 0038H
		MOV [SI], AX
		MOV AX, CS
		MOV SI, 003AH
		MOV [SI], AX
		CLI
		POP DS
		;��ʼ����Ƭ8259
		MOV AL, 11H				;���������ش�����ҪICW4
		OUT 20H, AL				;ICW1
		MOV AL, 08H				;�ж����ͺŴ�8��ʼ
		OUT 21H, AL				;ICW2
		MOV AL, 04H				; 
		OUT 21H, AL				;ICW3
		MOV AL, 01H				;�ǻ��巽ʽ��8086/8088����
		OUT 21H, AL				;ICW4
 
		;��ʼ����Ƭ8259
		MOV AL, 11H				;���������ش�����ҪICW4
		OUT 0A0H, AL			;ICW1
		MOV AL, 30H				;�ж����ͺŴ�30H��ʼ
		OUT 0A1H, AL			;ICW2
		MOV AL, 02H				;ͨ��IR1����������Ƭ
		OUT 0A1H, AL			;ICW3
		MOV AL, 01H				;�ǻ��巽ʽ��8086/8088����
		OUT 0A1H, AL			;ICW4
		MOV AL, 0FDH
		OUT 0A1H,AL				;��8259 OCW1 = 1111 1101	����IR1�ж�����	
		MOV AL, 2BH       		;0010 1011
		OUT 21H, AL				;��8259 OCW1	������IR2 IR4 IR6 IR7
		STI
 		
AA2:	NOP
		CMP BX,01H				;01H���������ƶ�
		JZ	AA3
		CMP BX,00H				;00H���������ƶ�
		JZ  AA4
		JMP AA2
		
AA3:
		MOV DX, 0642H
		IN AL,DX				;��b�ڶ���״̬
  
		CMP AL,01H				;���������Ҳ�
		JZ AA5					
    
		ROR AL,1				;ѭ������
		CALL DELAY
		OUT DX,AL				;��b��
		JMP AA2    
AA5: 	MOV BX,02H				;��־��ֹͣ
		JMP AA2
		
AA4:
		MOV DX, 0642H			;��b�ڶ���״̬
		IN AL,DX
    
		CMP AL,80H				;�����������
		JZ AA6
    
		ROL AL,1				;ѭ������
		CALL DELAY
		OUT DX,AL				;��b��
		JMP AA2    
AA6:	MOV BX,02H				;��־��ֹͣ
		JMP AA2
 
MIR7:	
		MOV BX,00H				;��־������
		PUSH AX					;����AX
		MOV AL, 20H
		OUT 20H, AL
		POP AX
		IRET
MIR6:	
		MOV BX,01H				;��־������
		PUSH AX					;����AX
		MOV AL, 20H
		OUT 20H, AL
		POP AX
		IRET

DELAY:	PUSH CX					;��ʱ�ӳ���
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