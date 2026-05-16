TITLE Algorithms via Procedures and Modularization     (Proj4_guardadd.asm)

; Author: Daniel Guardado
; Last Modified: 5/11/2026
; OSU email address: guardadd@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 4               Due Date: 5/17/2026
; Description: ********************************
;              when developing assembly projects in CS271.

INCLUDE Irvine32.inc

; (insert macro definitions here)

ROWS_MIN = 1
ROWS_MAX = 13

.data

programTitle	BYTE	"Pascal Triangle Program by Daniel Guardado",13,10,0
programIntro	BYTE	"This program can print up to 13 rows of Pascal's Triangle, per your specification.",13,10,0
rowInputPrompt	BYTE	"Enter total number of rows to print [1...13]: ",0
errorMessage	BYTE	"Input value is not within 1-13, please try again.",13,10,0
farewellMessage	BYTE	"Goodbye.",0

userInput		DWORD	?


.code
main PROC
	call introduction
	call getUserInput
	call printPascalTriangle
	call farewell
	Invoke ExitProcess,0	; exit to operating system
main ENDP

introduction PROC
	mov		edx, OFFSET programTitle
	call	WriteString
	mov		edx, OFFSET programIntro
	call	WriteString
	ret
introduction ENDP

getUserInput PROC
	_getInput:
		mov		edx, OFFSET rowInputPrompt
		call	WriteString
		call	ReadInt
		cmp		eax, ROWS_MIN
		jl		_error
		cmp		eax, ROWS_MAX
		jg		_error
		mov		userInput, eax
		ret
	_error:
		mov		edx, OFFSET errorMessage
		call	WriteString
		jmp		_getInput
getUserInput ENDP

printPascalTriangle PROC
	call	CrLf
	mov		ecx, userInput
	_printRow:
		push	ecx
		call	printPascalRow
		pop		ecx
		loop	_printRow
	ret
printPascalTriangle ENDP

printPascalRow PROC
	; TODO: call nChooseK (dont use array to collect [print each individually]) and go through each row individually. Push necessary value before calling nChooseK
	; Put whitespacing between nChooseK values, and display values until n=k before returning to printPascalTriangle to print next row


printPascalRow ENDP

nChooseK PROC
	push	ebp
	mov		ebp, esp

	mov		eax, [ebp+12]	;n value
	mov		ebx, [ebp+8]	;k value 
	; need more temp variables/regs for loops?

	_loop:
		; TODO: edge-cases, check if k=0 or k=n to give result '1' to avoid breaking
		; get numerator and multiply n*n-1*n-2... and reduce k until ecx <k
		_numerator:
			mov ecx, ebx
			mov 
			
			cmp
		; get denominator and multiply k * k-1 * k-2... until k=0
		_denominator:
			mov	
	; divide numerator by denominator to get single nCk to print here to send back to printPascalRow.
	_divideAndPrintResult:


	pop		ebp
nChooseK ENDP

farewell PROC
	mov		edx, OFFSET farewellMessage
	call	WriteString
farewell ENDP


END main
