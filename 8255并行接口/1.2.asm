CODE	SEGMENT	'CODE'
		ASSUME	CS:CODE
START:	MOV	DX,0646H
		MOV	AL,90H
		OUT	DX,AL
A:		MOV	DX,0640H
		IN	AL,DX
		CMP	AL,0FFH
		JZ	EXIT
		AND	AL,01H
		CMP	AL,1H
		JNZ	B
		MOV	AL,0F0H
		JMP	OUTPUT
B:		MOV	AL,0FH
OUTPUT:	MOV	DX,0642H
		OUT	DX,AL
		JMP A
EXIT:	MOV	DX,0642H
		MOV	AL,0H
		OUT	DX,AL
		MOV	AH,4CH
		INT 21H
CODE	ENDS
		END	START