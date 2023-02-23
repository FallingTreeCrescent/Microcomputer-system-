DATA SEGMENT
    SIGN DB 00H
DATA ENDS

CODE SEGMENT
             ASSUME CS:CODE,DS:DATA
  
    START:   
             MOV    AX,0000H
             MOV    DS,AX              ;设置数据段地址
      
    ;设置中断向量
             MOV    AX,OFFSET MIR7
             MOV    SI,003CH
             MOV    [SI],AX
             MOV    AX,CS
             MOV    SI,003EH
             MOV    [SI],AX
    
             CLI                       ;关中断
    
             MOV    AL, 11H
             OUT    20H, AL
             MOV    AL, 08H
             OUT    21H, AL
             MOV    AL, 04H
             OUT    21H, AL
             MOV    AL, 07H
             OUT    21H, AL
             MOV    AL, 2FH
             OUT    21H, AL
             STI                       ;开中断
    
    FIRST:   
             CMP    SIGN,00H
             JE     JUCHI
             CMP    SIGN,01H
             JE     JUXING
             CMP    SIGN,02H
             JE     SANJIAO
             CMP    SIGN,03H
             JE     JIETI0
             JMP    FIRST
    ;产生锯齿波
    
             MOV    CX,04H
    JUCHI:   
             CMP    SIGN,0H
             JNE    FIRST
             MOV    DX, 0600H
             MOV    AL, 00H
    JUCHI1:  
             OUT    DX, AL
             CALL   SHORT
        
             CMP    AL ,0FFH
             JE     JUCHI2
    
             INC    AL
             JMP    JUCHI1
    JUCHI2:  
             LOOP   JUCHI


    ;产生矩形波
             MOV    CX, 05H
    JUXING:  
             CMP    SIGN,01H
             JNE    FIRST
             MOV    DX, 0600H
             MOV    AL, 00H
             OUT    DX, AL
             CALL   LONG
             MOV    AL, 0FFH
             OUT    DX, AL
             CALL   LONG
             LOOP   JUXING

    ZJ:      JMP    FIRST

    ;产生三角波
             MOV    CX, 06H
    SANJIAO: 
    SANJIAO1:
             CMP    SIGN,02H
             JNE    FIRST
             MOV    DX, 0600H
             OUT    DX, AL
    
             CALL   SHORT
        
             CMP    AL,0FFH
             JE     SANJIAO2
             INC    AL
             JMP    SANJIAO1
    SANJIAO2:
             MOV    DX, 0600H
             OUT    DX, AL
             CALL   SHORT
        
             CMP    AL,00H
             JE     SANJIAO3
             DEC    AL
             JMP    SANJIAO2
    SANJIAO3:
             LOOP   SANJIAO
  
    ;产生阶梯波
    JIETI0:  
             MOV    CX, 07H
             MOV    AX, 0FEH

             MOV    BL,05H
             DIV    BL
             MOV    BL, AL
             MOV    BH, 00H
    JIETI1:  
             CMP    SIGN,03H
             JNE    ZJ
             MOV    AX,0000H
    JIETI1:  
             MOV    DX, 0600H
             OUT    DX, AL
             CMP    AX, 00FFH
             JAE    JIETI2
             CALL   LONG
    
             ADD    AX, BX
             JMP    JIETI1
    JIETI2:  
             LOOP   JIETI1
    MIR7:                              ;中断服务程序
             PUSH   AX
             CMP    SIGN,03H
             JE     AA
             INC    SIGN
             JMP    QUIT
    AA:      
             MOV    SIGN,0H
    QUIT:    
             POP    AX
             IRET


    SHORT:   
             PUSH   CX
             MOV    CX, 01FFH
    FLAG1:   
             PUSH   AX
             POP    AX
             LOOP   FLAG1
             POP    CX
             RET

    LONG:    
             PUSH   CX
             MOV    CX, 0FFFFH
    FLAG2:   
             PUSH   AX
             POP    AX
             LOOP   FLAG2
             POP    CX
             RET

CODE ENDS
    END START
