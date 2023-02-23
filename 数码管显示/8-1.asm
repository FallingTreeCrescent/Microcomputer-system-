DATA SEGMENT
     
LEBTAB DB 3FH   ;0
       DB 06H   ;1
       DB 5BH   ;2
       DB 4FH   ;3
       DB 66H   ;4
       DB 6DH   ;5
       DB 7DH   ;6
       DB 07H   ;7
       DB 7FH   ;8
       DB 6FH   ;9
       DB 77H   ;A
       DB 7CH   ;B
       DB 39H   ;C
       DB 5EH   ;D
       DB 79H   ;E
       DB 71H   ;F
DATA ENDS
CODE SEGMENT
     ASSUME CS:CODE,DS:DATA
START:
      MOV AX,DATA
      MOV DS,AX
      
      MOV DX,0606H
      MOV AL,80H
      OUT DX,AL
      
      MOV BX,OFFSET LEBTAB
X2:   MOV SI,0FFFFH
X1:   
      MOV AL,11011111B
      INC SI
      CMP SI,10H
      JE X2
      
FOR:  
      MOV DX,0600H
      OUT DX,AL
      ROR AL,1
      
      PUSH AX
      MOV DX,0602H
      MOV AL,[BX+SI]
      OUT DX,AL
      POP AX
      
      CALL DELAY
      CMP AL,01111111B
      JE X1
      
      JMP FOR
      

      
      
DELAY:
     PUSH CX
     MOV CX,0FFFFH
     LOOP $
     POP CX
     RET
      
CODE ENDS
     END START
     
 
      
      