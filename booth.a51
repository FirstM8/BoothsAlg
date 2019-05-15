;Booth's Algorithim standard, the end results can be found with R4 being the most significant byte and r7 being the least significant byte
;this leaves the end result of the calculation as R4;R7
	ORG 00
MAIN:	CLR C
	CLR A
	MOV R2, #00H   ; Start value of the "carry" byte
	MOV R4, #00H   ; The start value for ACC
	MOV R5, #08H   ; legnth of the numbers
	MOV R6, #01110001B ; Multiplicand 
	MOV R7, #01110111B ; Multiplier
	MOV A, R7 ;moves r7 into the acc

	MOV R0, #00H    ; Addtion Counter
	MOV R1, #00H    ; Subtraction Counter 
	MOV R2, #00H    ; Machine cycles
	MOV TL0, #00H   ; Clears Timer Byte
	MOV TMOD, #11H  ; Sets Timer Mod

	SETB TR0     ;Starts the Timer

HERE:	JNC SRS
	JC SRA 
STOP:	SJMP STOP


SRS:	JB ACC.0,SB   ; Checks for a shift and subtract
	MOV R7, A ; Moves AR7 back to R7 proper
	MOV A, R4 ; Pulls in R4 which is the MSB

	MOV C, ACC.7 ; Brings in the msbit into c for the shift
	
	RRC A     ; Rotates, saving carry to load into R7

	MOV R4,A  ; Puts away R4
	MOV A, R7 ; Brings back R7
	RRC A     ; Rotates R7 including the carry from R4     
	MOV R7, A ; Loads the updated value to R7 so we dont lose data
	MOV A, R7 ; Loads new R7 back to A, this is done just in case to varify correct data
	DJNZ R5, HERE ; Decrements R5 as the bit size counter
	CLR TR0   ; Stops Timer
        MOV R2, TL0  ; Moves timer value to R2
	SJMP STOP

SB:	MOV R7, A  ;Put away R7
	MOV A, R4  ; Pull in the actual MSByte

	SUBB A, R6  ; Add Multiplicand to MSByte
	INC R1      ; Add Subtraction

	MOV C, ACC.7 ; R4.7 into carry

	RRC A      ; Rotate, this finishes the Add shift step

	MOV R4, A  ; Put away the actual MSByte
	MOV A, R7  ; Pull in R7 again
	RRC A
	MOV R7, A
	DJNZ R5, HERE
	CLR TR0   ; Stops Timer
        MOV R2, TL0  ; Moves timer value to R2
	SJMP STOP
       	

SRA: 	JNB ACC.0, AD
	MOV R7, A ;Moves AR7 back to R7 proper
	MOV A, R4 ;Pulls in R4 which is the MSB

	MOV C, ACC.7 ;Pulls in msb from r4 into carry to keep the sign  ********

	RRC A     ; Rotates, saving carry to load into R7

	MOV R4,A  ; Puts away R4
	MOV A, R7 ; Brings back R7
	RRC A     ; Rotates R7 including the carry from R4    
	MOV R7, A ; Loads the updated value to R7 so we dont lose data
	MOV A, R7 ; Loads new R7 back to A, this is done just in case to varify correct data
	DJNZ R5, HERE ; Decrements R5 as the bit size counter
	CLR TR0   ; Stops Timer
        MOV R2, TL0  ; Moves timer value to R2
	SJMP STOP

AD:	MOV R7, A  ;Put away R7
	MOV A, R4  ; Pull in the actual MSByte


	ADD A, R6  ; Add Multiplicand to MSByte
	INC R0     ; Addition Counter

	MOV C, ACC.7 ; R4.7 into carry

	RRC A      ; Rotate, this finishes the Add shift step

	MOV R4, A  ; Put away the actual MSByte
	MOV A, R7  ; Pull in R7 again
	RRC A
	MOV R7, A
	DJNZ R5, HERE
	CLR TR0   ; Stops Timer
        MOV R2, TL0  ; Moves timer value to R2
        SJMP STOP

	END