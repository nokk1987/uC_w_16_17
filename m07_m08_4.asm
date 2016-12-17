;************************************************
;M07,M08 - matrix keyboard
;Excercise 2 (based on example from Galkas book)
;************************************************
lcd_clr    equ 810ch
delay_ms   equ 8110h
write_data equ 8102h
cskb0      equ 21h
cskb1      equ 22h
csds       equ 30h
csdb       equ 38h
led_ok     equ p1.6
disp       equ 01000000b  
cod        equ 00010000b
  
	       ljmp	start
	       org	100h
start:

           mov r1, #csds
           mov a, #disp
           movx @r1, a
           mov r1, #csdb
           mov a, #cod
           movx @r1, a		   
	       mov dptr, #key_code ;code tab adress

loop_no:
	       mov r0, #cskb0 ;0..7 keys adress
	       movx	a, @r0 ;read key status
	       cpl a ;complement necessary (negative logic of matrix keyboard)
	       jnz key_yes ;if key has been read jump
	       inc r0 ;8.. keys adress
	       movx	a, @r0
	       cpl a
	       jz loop_no ;if key has not been read jump

key_yes:			;debouncing
	       mov r2, a ;store key status
	       mov a, #10
	       lcall delay_ms
	       movx	a, @r0
	       cpl a
	       xrl a, r2 ;ex.: 0000.1000 XOR 0000.0100 = 0000.1100 
	       jnz loop_no ;if not zero then other key was pressed
				       ;if zero - key was pressed (stabilized)					  	   
           lcall lcd_clr
	       mov a, r2 ;key status back to a
			         ;set r2 accordingly to key status

	       mov r2, #07h ;8.. 
	       cjne	r0, #cskb0, loop_nr
	       mov	r2, #0ffh ;0..7 keys

loop_nr:			;key code -> corresponding nr 0..15
	       inc	r2		
	       rrc	a
	       jnc	loop_nr
	       cjne	r0, #cskb1, keys_disp ;for 0..7 keys jump
		   cjne r2, #0fh, no_cpl
           cpl led_ok ;if [F] key complement led ok
no_cpl:	
           cjne r2, #10, cont; r2>9
cont:	   
           jnc loop_yes ;if r2>9 do nothing 
		                ;(non-numeric key was pressed)
keys_disp:	
	       mov	a, r2 ;key nr -> corresponding ANSI
	       movc	a, @a+dptr ;sign from a tab
				
	       lcall write_data
	
loop_yes:
	       mov r0, #cskb0	
	       movx	a, @r0
	       cpl a
	       jnz loop_yes
	       inc r0	
	       movx	a, @r0		
	       cpl	a
	       jnz loop_yes

	       sjmp	loop_no
				
;**************************************
;key codes tab
key_code:
	       db	30h, 31h, 32h		;0,1,2
	       db	33h, 34h, 35h		;3,4,5
	       db	36h, 37h, 38h		;6,7,8
	       db	39H		            ;9
           end

