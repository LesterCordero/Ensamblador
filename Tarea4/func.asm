; --MACROS --
%macro setPuntero 1
	mov r12, 0
	mov r12b, byte[%1]
%endmacro
; -----------

SECTION .text
GLOBAL subseq                             
subseq:
; --PROLOGO --
	push rbp            	; guarda el base pointer
	mov rbp, rsp        	; rbp apunta hacia el top de la pila
	sub rsp, 3          	; reserva 3 "bytes"
	mov byte[rbp-1], 0  	; contador de desplazamiento de hile 1
	mov byte[rbp-2], 0  	; contador de desplazamiento de hile 2
	mov byte[rbp-3], 0  	; resultado de la funcion (para enviar por rax)
; --CUERPO --
compare:
	; evalua si no es subhilera cuando la hilera 1 llego a su fin
	setPuntero rbp-1		; r12 ahora tiene el contador para la hilera 1
	cmp byte[rdi+r12], 0	; si la hilera1 lego a su fin, NO es subhilera
	je final				; no es subhilera, termine el programa
	
	; esta seccion realiza la comparacion entre cada char de ambas hileras usando desplazamientos (r12)
	; rdi = ubicacion de hilera 1, rsi = ubicacion de hilera 2, r12 = desplazamiento relativo
	setPuntero rbp-2		; r12 ahora tiene el contador para la hilera 2
	mov al, byte[rsi+r12]   ; copia el char del de hile2 y lo guarda en "AL"
	setPuntero rbp-1        ; r12 ahora tiene el contador para la hilera 1
	inc byte[rbp-1]			; incremente el contador para el puntero de la hilera1 para la siguiente iteracion
	cmp byte[rdi+r12], al	; compara que el char guardado sea igual con el que apunta la hilera1
	
	; realiza el salto para seguir buscando el siguiente char en hilera en caso de no coincidir los chars
	jne compare				; si no son iguales, repita (ya el puntero apunta al siguiente)
	
	; acerto un char, sumele al contador de
	inc byte[rbp-2]			; incremente el contador para el puntero de la hilera2
	setPuntero rbp-2		; r12 ahora tiene el contador de la hilera 2
	cmp byte[rsi+r12], 0	; si la hilera 2 llega a su fin, significa que SI es subsecuencia
	jne compare				; si no ha llegado a su fin, siga comparando
	
	; lo logro, coloque un 1 indicando que es subsecuencia
	mov byte[rbp-3], 1      ; si es subsecuencia, coloque 1 en la variable de retorno
final:
; --EPILOGO --
	mov rax, 0              ; limpia RAX de posible basura
	mov al, byte[rbp-3]     ; coloca el resultado en rax
	add rsp, 3         		; elimina los 3 "bytes" reservados 
	pop rbp            		; recupera el base pointer
	ret						; retorna el control al programa de C
