; ECE 362 Lab 3 - Fall 2015 - Step 1

; Name: < Tian Qiu >

; Lab: < Section 7, TR 11:30 - 2:30 >

; Class Number: < 5063-Q >

; Use Code Warrior (CW) in Full Chip Simulation mode

;***********************************************************************
; Write a subroutine "correl" that calculates the correlation between
; two 16-bit binary values, where the correlation is defined as the
; number of corresponding bit positions that are identical.
;
; At entry, the X and Y registers contain the two 16-bit operands;
; at exit, the B register contains the correlation value (which can
; range from $00 to $10).
;
; Examples:
;
; if   (X) = %10101010 01010101 = $AA55 and (Y) = %01010101 10101010 = $55AA
; then (B) = $00
;
; if   (X) = %11001100 11001100 = $CCCC and (Y) = %01010101 10101010 = $55AA
; then (B) = $08
;
; if   (X) = %00000000 00000000 = $0000 and (Y) = %00000000 00000000 = $0000
; then (B) = $10
;
;***********************************************************************
;
; To test and auto-grade your solution:
;	- Use CodeWarrior to assemble your code and launch the debugger
;	- Load the Auto-Grader (L3AG-3.s19) into the debugger
;		> Choose File -> Load Application
;		> Change the file type to "Motorola S-Record (*.s*)"
;		> Navigate to the 'AutoGrade' folder within your project
;		> Open 'L3AG-3.s19'
; - Open and configure the SCI terminal as a debugger component
;	- Start execution at location $800
;
; The score displayed is the number of test cases your code has passed.
; If nothing is displayed (i.e., your code "crashes"), no points will be
; awarded - note that there is no way to "protect" the application that
; tests your code from stack errors inflicted by mistakes in your code.
;
; Also note: If the message "STACK CREEP!" appears, it means that the
; stack has not been handled correctly (e.g., more pushes than pops or
; data passed to it not de-allocated correctly). 
;
;***********************************************************************

	org	$A00	; DO NOT REMOVE OR MODIFY THIS LINE

; Place your code for "correl" below

correl  
        stx  store_x		; (store_x)=(X) 
        exg  y,d		; exchange the contents of Y and D
        eora store_x		; (A)xor(store_x)=>(A)
        eorb store_x+1		; (B)xor(store_x+1)=>(B)
        coma			; complement(A)=>(A)
        comb			; complement(B)=>(B)
        ldy  #0			; (Y)=0
cor_count
        tsta			; test (A) is zero
        beq  check_zero		; branch to check_zero if equal
        bra  correl_cont	; branch to correl_cont
check_zero
        tstb			; test (B) is zero
        beq  corexit		; branch to corexit
correl_cont
        lsld			; logical shift left C <- D <- 0
        bcs  increment		; branch to increment if C set(carry=0)
        bra  cor_count        	; branch to cor_count
increment        
        iny			; (Y)+$0001=>(Y)
        bra  cor_count		; branch to cor_count

corexit
        pshy			; (Y)=>(SP)
        pula			; (SP)=>(A)
        pulb			; (SP)=>(B)
     	  rts			; (M(SP):M(SP+1))=>PC(h):PC(l) SP+2=>SP
store_x
        rmb 2


	end