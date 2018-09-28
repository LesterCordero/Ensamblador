; --MACROS --
%macro setPuntero 1
	mov r12, 0
	mov r12b, byte[%1]
%endmacro

; prologo que prepara la pila
%macro prologo 0
	push rbp            	; guarda el base pointer
	mov rbp, rsp        	; rbp apunta hacia el top de la pila
	sub rsp, 3          	; reserva 3 "bytes"
	mov byte[rbp-1], 0  	; contador de desplazamiento de hile 1
	mov byte[rbp-2], 0  	; contador de desplazamiento de hile 2
	mov byte[rbp-3], 0  	; resultado de la funcion (para enviar por rax)
%endmacro

; esta seccion realiza la comparacion entre cada char de ambas hileras usando desplazamientos (r12)
; rdi = ubicacion de hilera 1, rsi = ubicacion de hilera 2, r12 = desplazamiento relativo
%macro compareChars 0
	setPuntero rbp-2	; r12 ahora tiene el contador para la hilera 2
	mov al, byte[rsi+r12]   ; copia el char del de hile2 y lo guarda en "AL"
	setPuntero rbp-1        ; r12 ahora tiene el contador para la hilera 1
	inc byte[rbp-1]		; incremente el contador para el puntero de la hilera1 para la siguiente iteracion
	cmp byte[rdi+r12], al	; compara que el char guardado sea igual con el que apunta la hilera1
%endmacro

; libera la pila y envia el resultado a RAX
%macro epilogo 0
	mov rax, 0              ; limpia RAX de posible basura
	mov al, byte[rbp-3]     ; coloca el resultado en rax
	add rsp, 3         	; elimina los 3 "bytes" reservados 
	pop rbp            	; recupera el base pointer
%endmacro

SECTION .text
; -- SUBSECUENCIA -------------------------------------------------------------------------------------
GLOBAL subseq                             
subseq:
; --PROLOGO --

	prologo					; llame al prologo común
	
; --CUERPO --
compare_subseq:

	; evalua si no es subhilera cuando la hilera 1 llego a su fin
	setPuntero rbp-1	; r12 ahora tiene el contador para la hilera 1
	cmp byte[rdi+r12], 0	; si la hilera1 lego a su fin, NO es subsecuencia
	je final_subseq		; no es subsecuencia, termine el programa
	
	compareChars		; llame al comparador de chars
	
	; realiza el salto para seguir buscando el siguiente char en hilera en caso de no coincidir los chars
	jne compare_subseq	; si no son iguales, repita (ya el puntero apunta al siguiente)
	
	; acerto un char, sumele al contador de
	inc byte[rbp-2]		; incremente el contador para el puntero de la hilera2
	setPuntero rbp-2	; r12 ahora tiene el contador de la hilera 2
	cmp byte[rsi+r12], 0	; si la hilera 2 llega a su fin, significa que SI es subsecuencia
	jne compare_subseq   	; si no ha llegado a su fin, siga comparando
	
	; lo logro, coloque un 1 indicando que es subsecuencia
	mov byte[rbp-3], 1      ; si es subsecuencia, coloque 1 en la variable de retorno
	
; --EPILOGO --	
final_subseq:

	epilogo			; llame al epilogo común
	ret			; retorna el control al programa de C
	
; -- SUBHILERA -------------------------------------------------------------------------------------	
GLOBAL subhile                             
subhile:
; --PROLOGO --

	prologo			; llame al prologo común
	
; --CUERPO --
fallo_subhile:

	mov byte[rbp-2], 0	; la hilera no estaba consecutiva, devuelva el contador a 0
	
compare_subhile:

	; los jumps ahora son respecto a subhilera
	setPuntero rbp-1	; r12 ahora tiene el contador para la hilera 1
	cmp byte[rdi+r12], 0	; si la hilera1 lego a su fin, NO es subhilera
	je final_subhile	; no es subhilera, termine el programa
	
	compareChars		; llame al comparador de chars
	jne fallo_subhile	; igual que subseq, repita si no coinciden
	
	; practicamente igual que subsecuencia, pero con la diferencia de que si falla, setee el contador en 0 de nuevo
	inc byte[rbp-2]		; incremente el contador para el puntero de la hilera2
	setPuntero rbp-2	; r12 ahora tiene el contador de la hilera 2
	cmp byte[rsi+r12], 0	; si la hilera 2 llega a su fin, significa que SI es subsecuencia
	jne compare_subhile   	; si no ha llegado a su fin, siga comparando
	
	mov byte[rbp-3], 1      ; si es subhilera, coloque 1 en la variable de retorno
	
; --EPILOGO --	
final_subhile:

	epilogo			; llame al epilogo común
	ret			; retorna el control al programa de C
