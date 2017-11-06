;Debouncing os switches
org 00H
ljmp main

org 01BH
ljmp timer_int1

org 100H
start_timer:
	mov TMOD,#10H
	mov IE,#88H
	clr TF1
	setb TR1
ret


main:
	mov P1,#0FH					
	mov 4FH,P1					;Prev value stored in 4FH
	acall start_timer
	
	stop: sjmp stop

org 200H
	;---------------------------------Timer0 Interrupt-------------------------
timer_int1:						;Current stable value at 4FH and prev stable value at 4EH
	mov  A,P1					
	anl  A,#0FH
	cjne A,4FH,new				
	mov 4EH,4FH					;Prev state is same as current
	sjmp var
	new:
		cjne A,4DH,new2			;If already occured then 4FH = 4EH
		mov  4EH,4FH			;4EH now stores the previous stable state
		mov  4FH,4DH			;4FH, current state changes
		sjmp var
	new2:
		mov 4DH,A				
		mov 4EH,4FH
	var:
		mov P1,#0FH				
		mov TH1,#64H
reti

end