A8255 EQU 0600H
B8255 EQU 0602H
C8255 EQU 0604H
CON8255 EQU 0606H  
;0809ʹ��IOY1Ƭѡ�ź�
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
    OUT DX,AL      ;����1ͨ��	
    MOV DX, A0809  
    OUT DX, AL     ;����AD����
X1: 
    MOV DX,A8255
    IN AL,DX       ;��8255A�ڶ���EOC״̬
    TEST AL,80H    ;����ǲ��Ǹߵ�ƽ����ʾδ���ת��
    JNZ X1         
X2:
    MOV DX,A8255
    IN AL,DX       ;��8255A�ڶ���EOC״̬   
    TEST AL,80H    
    JZ X2          ;����Ǹߵ�ƽ����ʾװ��δ���
 
    MOV DX,A0809
    IN AL,DX       ;��ADC0809����ת����ɵ�����
    MOV DX, B8255
    OUT DX,AL      ;��8255B�����ת����ɵ�����
    JMP X3         ;ѭ��ת��
CODE ENDS 
    END START
