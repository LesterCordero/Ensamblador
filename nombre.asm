; lester cordero
; b62110

section  .text
global apellidosFirst
apellidosFirst:
	push rbx                       ; desde donde quiere hacer el shift
	push r8                        ; char de reemplazo
	push r9                        ; iterador en reversa
	push r10                       ; ultimo char de la hilera
	push r11                       ; tam de la hilera
	push r12                       ; contador de blancos
	mov rbx, 0                     ; limpie basura si hace falta 
	mov r8,  0                     ; limpie basura si hace falta 
	mov r9,  0                     ; limpie basura si hace falta 
	mov r10, 0                     ; limpie basura si hace falta 
	mov r11, 0                     ; limpie basura si hace falta 
	mov r12, 0                     ; limpie basura si hace falta
	dec r11                        ; al iniciar el loop, la devuelve a 0
cuenteHilera:
	inc r11                        ; incremente
	cmp byte[rdi+r11], 0           ; compara si el fin
	jne cuenteHilera               ; sigue buscando el fin
	mov r9, r11                    ; copie el tam de la hilera en otro reg para no perder el tam que ya teniamos calculado
busqueBlancoMasProximo:
	cmp r9, 0                      ; si llega al inicio de la hilera y no hay blancos, no haga nada
	je termine                     ; salte si no tiene que hacer shift
	dec r9
	cmp byte[rdi+r9+1], 32         ; compara si es un espacio
	jne busqueBlancoMasProximo     ; repite cuando NO sea blanco
	inc r12                        ; incrementa numero de espacios blancos (pueden ser muchos blancos)
	cmp r12, 2                     ; cuando hay 2 blancos, salte a los shifts
	je continue
busqueCharMasProximo:
	dec r9                         ; recorra r9-- hasta que no tenga blancos 
	cmp byte[rdi+r9+1], 32         ; ¿es blanco r9?
	je busqueCharMasProximo        ; repita si debe de hacerlo
	jmp busqueBlancoMasProximo     ; ahora repita cuando encuentra desde un grupo de chars encuentre otro blanco de OTRO grupo de letras
continue:
	mov rax, r11
	sub rax, r9                    ; cuantos shifts va hacer
	sub rax, 2                     ; restele 2 para que no cuente el ultimo 0 y el se mueve al char siguiente depsues

	mov r9, r11                    ; ahora reutilize r9 de nuevo como otro contador empezando desde el final de la hilera
	
shiftCircular_inicio:
	mov r10b, byte[rdi+r11-1]      ; guarda el ultimo shift de la hilera para mandarlo a la izquierda
	mov r9, r11                    ; copie el tam de la hilera en otro reg para no perder el tam que ya teniamos calculado
shiftCircular_loop:
	dec r9                         ; es un contador en reversa, decrementelo
	mov r8b, byte[rdi+r9-1]        ; copie el bit anterior al actual ... 3, 4 ....
	mov byte[rdi+r9], r8b          ; y peguelo al actual             ... 3, 3 ....
	cmp r9, 0                      ; y repita hasta que haya ocurrido con todos
	jg shiftCircular_loop          ; quedando asi                    1, 1, 2, 3...
	mov byte[rdi], r10b            ; copie el ultimo elemento        9, 1, 2, 3... 
	dec rax                        ; decremente el numero de shifts
	cmp rax, 0                     ; compare para evaluar si el contador de shifts > 0
	jg shiftCircular_inicio        ; si aun faltan shifts, entonces siga haciendo shifts
termine:
	mov byte[rdi+r11], 0           ; asegurese que haya un 0 al final de la hilera
	mov rax, r11                   ; coloque tam de la hilera
	pop rbx                        ; recupere los valores
	pop r12                        
	pop r11                        
	pop r10
	pop r9
	pop r8
	ret
