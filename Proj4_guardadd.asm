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

userInput		DWORD	?


.code
main PROC
	call introduction
	call getUserInput


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





END main
