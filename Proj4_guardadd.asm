TITLE Pascal Triangle Program    (Proj4_guardadd.asm)

; Author: Daniel Guardado
; Last Modified: 5/16/2026
; OSU email address: guardadd@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 4               Due Date: 5/17/2026
; Description:	This program gets a user value (row count in range 1-20) to be used for forming a
;				Pascal Triangle. The appropriate values in each row are then calculated through
;				n-choose-k operations until every row has been printed.

INCLUDE Irvine32.inc

ROWS_MIN = 1
ROWS_MAX = 20

.data

programTitle	BYTE	"Pascal Triangle Program by Daniel Guardado",13,10,0
programIntro	BYTE	"This program can print up to 20 rows of Pascal's Triangle, per your specification.",13,10,0
extraCredit2	BYTE	"**EC: This program prints up to 20 rows of Pascal's Triangle.",13,10,13,10,0
rowInputPrompt	BYTE	"Enter total number of rows to print [1...20]: ",0
errorMessage	BYTE	"Input value is not within 1-20, please try again.",13,10,0
farewellMessage	BYTE	"Thank you for using Pascal Triangle Program. Goodbye.",13,10,0

userInput		DWORD	?	; Holds row integer value for Pascal Triangle.


.code
main PROC
	; Introduce user, print full pascal triangle based on row input, and display goodbye message.
	call introduction
	call getUserInput
	call printPascalTriangle
	call farewell
	Invoke ExitProcess,0
main ENDP

; ----------------------------------------------------------
; Name: introduction
; 
; Introduce the program title and introduction to the user.
;
; Preconditions: none
;
; Postconditions: none
;
; Receives: none
;
; Returns: none
; ----------------------------------------------------------
introduction PROC
	mov		edx, OFFSET programTitle
	call	WriteString
	mov		edx, OFFSET programIntro
	call	WriteString
	mov		edx, OFFSET extraCredit2
	call	WriteString
	ret
introduction ENDP

; -------------------------------------------------------------------
; Name: getUserInput
; 
; Gets and validates an integer from the user within the range 1-20.
;
; Preconditions: none
;
; Postconditions: none
;
; Receives: none
;
; Returns: userInput = rows value
; -------------------------------------------------------------------
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

; ------------------------------------------------------------
; Name: printPascalTriangle
; 
; Prints pascal triangle based on row count from user input 
; until all rows are printed.
;
; Preconditions: user row input has been collected and validated
;
; Postconditions: none
;
; Receives: userInput = rows value
;
; Returns: none
; ------------------------------------------------------------
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

; ------------------------------------------------------------
; Name: printPascalRow
; 
; prints each nCk value, adds whitesspacing
;
; Preconditions: ECX is preserved
;
; Postconditions: none
;
; Receives: userInput = rows value
;
; Returns: none
; ------------------------------------------------------------
printPascalRow PROC
	mov  eax, userInput
	sub  eax, ecx         ; eax = current row 'n' (0-indexed)
	mov  ebx, eax         ; ebx = n (parameter for nChooseK)
	
	mov  edi, 0           ; edi = k counter (starts at 0)
	mov  edx, ecx         ; Save outer loop counter in EDX safely

	_rowLoop:
		cmp  edi, ebx         ; Loop while k <= n
		jg   _rowFinished

		mov  eax, edi         ; eax = k (parameter for nChooseK)
		call nChooseK         ; Calculates and prints the number
	
		mov  al, ' '          ; Print a space spacer
		call WriteChar

		inc  edi              ; k++
		jmp  _rowLoop

	_rowFinished:
		call CrLf
		mov  ecx, edx         ; Restore outer loop counter to ECX
		ret
printPascalRow ENDP

nChooseK PROC
	push ebx              ; Preserve registers we will mutate
	push ecx

	mov  ecx, eax         ; ecx = k (our loop limit)
	mov  eax, 1           ; Running total starts at 1
	mov  esi, 1           ; esi = running divisor (starts at 1)

	cmp  ecx, 0           ; If k == 0, skip loop completely (result is 1)
	je   _printResult

	_calcLoop:
		mul  ebx              ; edx:eax = total * n
		div  esi              ; eax = total / divisor
	
		dec  ebx              ; n--
		inc  esi              ; divisor++
		loop _calcLoop        ; Decrements ECX and loops until ECX == 0

	_printResult:
		call WriteDec
	
		pop  ecx              ; Restore registers
		pop  ebx
		ret
nChooseK ENDP

farewell PROC
	call CrlF
	mov		edx, OFFSET farewellMessage
	call	WriteString
farewell ENDP

END main
