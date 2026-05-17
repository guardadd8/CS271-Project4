TITLE Pascal Triangle Program    (Proj4_guardadd.asm)

; Author: Daniel Guardado
; Last Modified: 5/17/2026
; OSU email address: guardadd@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 4               Due Date: 5/17/2026
; Description:	This program gets a user value in the range 1-20 (for row count) to be used for forming a
;				Pascal Triangle. The appropriate element values in each row are then calculated through
;				n-choose-k operations until every row has been displayed with proper values.

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

	userInput		DWORD	?	; Holds row integer value

.code
; -------------------------------------------------------------------------
; Name: main
; 
; Program entry point where procedures are called to display introduction,
; get user input, print pascal triangle, and display departing message.
; -------------------------------------------------------------------------
main PROC
	call	introduction
	call	getUserInput
	call	printPascalTriangle
	call	farewell
	Invoke	ExitProcess,0
main ENDP

; -------------------------------------------------------------------------
; Name: introduction
; 
; Introduce the program title and introduction to the user.
;
; Preconditions: programTitle, programIntro, and extraCredit2 are defined
;
; Postconditions: EDX is changed
;
; Receives:
;		programTitle, programIntro, extraCredit2 are global variables
; -------------------------------------------------------------------------
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
; Postconditions: EAX, EDX are changed
;
; Receives: 
;		ROWS_MIN = minimum row value boundary
;		ROWS_MAX = maximum row value boundary
;		rowInputPrompt, errorMessage are global variables
;
; Returns: userInput = row integer value
; -------------------------------------------------------------------
getUserInput PROC
	; Prompt the user for an integer.
	_getInput:
		mov		edx, OFFSET rowInputPrompt
		call	WriteString
		call	ReadInt
		cmp		eax, ROWS_MIN				; check user input is >= 1
		jl		_error
		cmp		eax, ROWS_MAX				; check user input is <= 20
		jg		_error
		mov		userInput, eax
		ret
	; Display an error message if input is outside 1-20 range.
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
; Preconditions: userInput contains validated row input value
;
; Postconditions: ECX is changed
;
; Receives: userInput = row integer value
; ------------------------------------------------------------
printPascalTriangle PROC
	call	CrLf
	mov		ecx, userInput
	; Loop through each row sequentially while preserving the outer loop counter.
	_printRow:
		push	ecx
		call	printPascalRow
		pop		ecx
		loop	_printRow
	ret
printPascalTriangle ENDP

; -----------------------------------------------------------------------------
; Name: printPascalRow
; 
; Displays a single row of the Pascal triangle with proper values and spacing.
;
; Preconditions: ECX contains current outer loop countdown value
;
; Postconditions: EAX, EBX, EDX, ESI, and EDI are changed
;
; Receives:
;		ECX = current loop countdown index
;		userInput = row integer value
; ------------------------------------------------------------------------------
printPascalRow PROC
	; Calculate the current row number 'n' based on the loop counter countdown and initialize 'k' index counter to 0.
	mov		eax, userInput
	sub		eax, ecx			; eax = current row 'n'
	mov		ebx, eax			; ebx = n value
	mov		edi, 0				; edi = k counter
	
	_rowLoop:
		cmp		edi, ebx		; check k <= n
		jg		_finished

		mov		eax, edi		; eax = k
		call	nChooseK         
	
		mov		al, ' '
		call	WriteChar

		inc		edi				; increase k for next nCk value
		jmp		_rowLoop

	_finished:
		call	CrLf
		ret
printPascalRow ENDP

; --------------------------------------------------------------------------
; Name: nChooseK
; 
; Calculates and prints the current Pascal triangle element value using
; the multiplicative formula for nCk.
;
; Preconditions: EAX has k value, EBX has n value.
;
; Postconditions: EAX, EDX, and ESI are changed. EBX and ECX are preserved.
;
; Receives: 
;		EAX = 'k' index value
;		EBX = 'n' row value
;
; Returns: Calculated decimal value is printed onto console.
; ---------------------------------------------------------------------------
nChooseK PROC
	; Preserve EBX/ECX registers. Setup multiplier/divisor with value '1'.
	push	ebx
	push	ecx
	mov		ecx, eax			; loop counter 'k' (limit)
	mov		eax, 1				; multiplier
	mov		esi, 1				; divisor
	cmp		ecx, 0				; skip loop if k=0
	je		_printValue
	; Calculate element value by multiplying 'n' values and dividing by 'k' values using multiplicative formula.
	_calculate:
		mul		ebx				; edx:eax = total * n
		div		esi				; eax = total / divisor
		dec		ebx
		inc		esi
		loop	_calculate
	; Print calculated element value and restore registers.
	_printValue:
		call	WriteDec
		pop		ecx
		pop		ebx
		ret
nChooseK ENDP

; -----------------------------------------------
; Name: farewell
;
; Displays a goodbye message to the user.
;
; Preconditions: farewellMessage is defined
;
; Postconditions: EDX is changed
;
; Receives: farewellMessage is a global variable
; -----------------------------------------------
farewell PROC
	call	CrLf
	mov		edx, OFFSET farewellMessage
	call	WriteString
	ret
farewell ENDP

END main
