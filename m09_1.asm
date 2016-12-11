lcdwc        equ 80h
lcdwd        equ 81h
lcdrc        equ 82h
wait_key     equ 811ch
wait_100ms   equ 8112h
write_text   equ 8100h

				  			 
             ljmp start
		     org 100h
start:
             mov r0, #lcdwc
			 mov a, #1
			 lcall write_code
			 
             mov  a, #50h
			 lcall write_code
			 
			 mov dptr, #letter_l
			 mov r3, #16
			 
loop:
             clr a
             movc a, @a+dptr
             lcall write_data
             inc dptr
             djnz r3, loop
              			 
			 
main:			 
             lcall wait_key
             mov dptr, #text
             lcall write_text			 
             sjmp main			 
			 
;;;;write_code procedure;;;;			 
write_code:
             push acc
             lcall write
			 mov r0, #lcdwc
			 movx @r0, a
			 pop acc
			 ret
			 
;;;;write_data procedure;;;;			 
write_data:
             lcall write
             mov r0, #lcdwd
             movx @r0, a 			 
			 mov a, r2
			 anl a, #7fh
			 cjne a, #0fh, not_eq 
			 mov a, #0c0h
			 lcall write_code
not_eq:		 
             jc return
			 cjne a, #4fh, return
			 mov a, #80h
			 lcall write_code
return:			 
 			 ret
			 
;;;;write procedure;;;;	
write:
             push acc	 
             mov r0, #lcdrc
busy:			 
			 movx a, @r0
			 jb acc.7, busy
			 mov r2, a
			 pop acc
             ret
			 
;;;;additional letters;;;;			 
letter_l:
             db 00000110b
             db 00000011b
             db 00000010b
             db 00000110b
             db 00000010b
             db 00000010b
             db 00000111b
             db 00000000b
letter_a:
             db 00000000b
             db 00000000b
             db 00001110b
             db 00000001b
             db 00001111b
             db 00010001b
             db 00001110b
             db 00000100b
text:
             db ' ',2,3,'c','z','n','i','k',0			 
			
             end		 