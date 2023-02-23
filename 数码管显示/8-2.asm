DATA SEGMENT
LEDTABLE DB 06H   ;1
         DB 5BH   ;2
         DB 4FH   ;3
         DB 66H   ;4
         DB 6DH   ;5
         DB 7DH   ;6
DATA ENDS
CODE SEGMENT
     ASSUME CS:CODE,DS:DATA
START:
     MOV AX,DATA
     MOV DS,AX
     
     MOV DX,0606H
     MOV AL,80H
     OUT DX,AL
     
     MOV BX,OFFSET LEDTABLE
X1:  MOV SI,0FFFFH 
     MOV AL,11111110B
     
FOR1:
     INC SI
     
     MOV DX,0600H
     OUT DX,AL
     
     PUSH AX
     MOV DX,0602H
     MOV AL,[BX+SI]
     OUT DX,AL
     CALL DELAY
     POP AX
     
     ROL AL,1
     CMP AL,10111111B
     JE X1
     JMP FOR1 
     
DELAY:
     PUSH CX
     MOV CX,0FH
     LOOP $
     POP CX
     RET
     
CODE ENDS
     END START