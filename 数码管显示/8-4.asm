A8255_CON EQU 0606H
A8255_A EQU 0600H
A8255_B EQU 0602H
A8255_C EQU 0604H

DATA SEGMENT
TABLE1:
    DB 06H
    DB 5BH
    DB 4FH
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    
    MOV DX,0606H
    MOV AL,81H
    OUT DX,AL
    
    MOV DL,11111110B
    
    PUSH DS
    MOV AX, 0 
    MOV DS, AX
    MOV AX,OFFSET MIR6
      MOV SI,38H
      MOV [SI],AX
      MOV AX,CS
      MOV SI,3AH
      MOV [SI],AX
      POP DS
      
      CLI
      MOV AL,11H
      OUT 20H,AL
      MOV AL,08H
      OUT 21H,AL
      MOV AL,04H
      OUT 21H,AL
      MOV AL,07H
      OUT 21H,AL
      MOV AL,2FH
      OUT 21H,AL
      STI
      
      PUSH DX
      MOV DX,0646H
      MOV AL,76H
      OUT DX,AL
      MOV DX,0642H
      MOV AL,00H
      OUT DX,AL
      MOV AL,48H
      OUT DX,AL
      POP DX
      
X:    MOV CX,3
      MOV BX,OFFSET TABLE1
      MOV AL,DL
FOR1: 
      PUSH DX
      MOV DX,0600H
      OUT DX,AL
      
      PUSH AX
      MOV AL,[BX]
      MOV DX,0602H
      OUT DX,AL
      CALL DELAY
      POP AX
      POP DX
      
      INC BX
      ROL AL,1
      LOOP FOR1
      
      JMP X
    
    
    
MIR6:
     ROL DL,1
     CMP DL,10111111B
     JNZ EN
     MOV DL,11111110B
EN:  IRET

DELAY:
	PUSH CX
	MOV CX, 0FH
	LOOP $
	POP CX
	RET
CODE ENDS
     END START
    