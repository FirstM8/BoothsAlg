;Add and Shift Algorithm, the end results can be found with R4 being the most significant byte and r7 being the least significant byte
;this leaves the end result of the calculation as R4;R7
	ORG 00		; Add and Shift
MAIN:	CLR C
	CLR A
	MOV R4, #00H   ; The start value for ACC
	MOV R5, #08H	; legnth of the numbers
	MOV R6, #01110001B ;Multiplicand 
	MOV R7, #01110111B ; Multiplier
	
	MOV R0, #00H    ; Addtion Counter
	MOV R2, #00H    ; Machine cycles
	MOV TL0, #00H   ; Clears Timer Byte
	MOV TMOD, #11H  ; Sets Timer Mod

	SETB TR0
	MOV A, R7 ;moves r7 into the acc
	;CLR C  
	;RRC A
HERE:	JB ACC.0, AD
	CLR C
	MOV R7, A ;Moves AR7 back to R7 proper
	MOV A, R4 ;Pulls in R4 which is the MSB
	RRC A     ;Rotates, saving carry to load into R7
	MOV R4,A  ;Puts away R4
	MOV A, R7 ;Brings back R7
	RRC A     ;Rotates R7 including the carry from R4
	CLR C     
	MOV R7, A ;Loads the updated value to R7 so we dont lose data
	MOV A, R7 ;Loads new R7 back to A, this is done just in case to varify correct data
	DJNZ R5, HERE ;Decrements R5 as the bit size counter
	CLR TR0   ; Stops Timer
        MOV R2, TL0  ; Moves timer value to R2
STOP:   SJMP STOP

AD:	
	MOV R7, A  ;Put away R7
	MOV A, R4  ;Pull in the actual MSByte
	ADD A, R6  ; Add Multiplicand to MSByte
	INC R0     ; Counts Addition
	RRC A      ; Rotate, this finishes the Add shift step
	MOV R4, A  ; Put away the actual MSByte
	MOV A, R7  ; Pull in R7 again
	RRC A
	CLR C
	DJNZ R5, HERE
	CLR TR0   ; Stops Timer
        MOV R2, TL0  ; Moves timer value to R2
        SJMP STOP

	END
 ;1b9 is end result
 ;15H is both mult and ply
 ;The MSB is r4 while the LSB is r7 so result would be R4:R7 added together in hex for test data this gives R4=01 and R7=B0