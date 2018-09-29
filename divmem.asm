; lester cordero
; b62110

section .bss
cociente   resq  1
residuo    resq  1
result1    resq  5
result2    resq  5

section .data
dividendo  dq    1000
divisor    dq    67
dat1       dq    56763, 100, -100, 100, -100
dat2       dq    346,  18,   18, -18,  -18

linea   db  "Al dividir %8ld entre %8ld produce cociente =%5ld,  y residuo =%5ld",10,0
errmsg  db  "Error, registro modificado",10,0

%macro divida 4

	push rax   ; divisor
	push rdx   ; diviendo
	push r8    ; guardelo, lo usaremos como variable de signo de diviendo
	push r9    ; guardelo, lo usaremos como variable de signo de divisor
	
	mov r8, 0 ; 0 = num +
	mov r9, 0 ; 0 = num +
	
	; guarde los signos y haga la operacion como positivos
	
	cmp qword[%1], 0        ; si diviendo es menor
	jl %%dividendoNegativo  ; salte si el divisor < 0
	jmp %%continue1         ; sino, continue normalmente
	
	cmp qword[%2], 0        ; si divisor es menor
	jl %%divisorNegativo    ; salte si el diviendo < 0
	jmp %%continue1         ; sino, continue normalmente
	
%%dividendoNegativo:

	mov r8, 1      ; 1 = num es -
	neg qword[%1]  ; complemente hacia un positivo

%%divisorNegativo:

	mov r9, 1      ; 1 = num es -

%%continue1:
	
	mov rax, [%1]   ; el numero pongalo en rax
	cdq             ; rax -> rdx:rax
	idiv qword [%2] ; divida rdx:rax contra el %2, colocando el resultado en rax y el residuo en rdx
	
	; para mi caso, complementa al diviendo si es negativo y lo hace positivo
	; el divisor siempre lo deja del mismo signo
	; esto lo hice para que se cumpla la condicion diviendo = divisor * cociente + residuo
	; el residuo es del mismo signo que el dividendo
	; el cociente solo es negativo si el dividendo o el divisor, lo son
	
	mov [%3], rax   ; obtenga el resultado
	mov [%4], rdx   ; obtenga el residuo
	
	; ahora complemente para que los datos queden correctos
	cmp r8, 1       ; si sabemos que el dividendo era negativo, regreselo a negativo
	jne %%continue2 ; sino, continue
	neg qword[%1]   ; de vuelva a negativo
	neg qword[%4]   ; residuo es del mismo signo que el dividendo
	cmp r9, 1       ; el dividendo ya sabemos que es negativo y ahora el divisor tambien lo es, complemente el cociente
	jne %%continue2 ; sino siga normalmente
	neg qword[%3]   ; complemente el cociente
	
%%continue2:
	; recupere los valores
	pop r9 
	pop r8
	pop rdx
	pop rax
	
%endmacro

global main
extern printf
section  .text
main:
       divida dividendo, divisor, cociente, residuo
       mov rax, 0
       mov rdi, linea
       mov rsi, [dividendo]
       mov rdx, [divisor]
       mov rcx, [cociente]
       mov r8,  [residuo]
       call printf

       mov rax, -1
       mov rbx, -2
       mov rdx, -3
       mov rsi, -4
       mov rdi, -5
       mov r8, -6
       mov r9, -7
       mov r10, -8
       mov r11, -9
       mov r13, -10
       mov r14, -11
       mov r15, -12
       
       mov rcx, 5
       xor r12, r12

again:       
       divida dat1+r12*8, dat2+r12*8, result1+r12*8, result2+r12*8
       cmp rax, -1
       jne abort
       cmp rbx, -2
       jne abort
       cmp rdx, -3
       jne abort
       cmp rsi, -4
       jne abort
       cmp rdi, -5
       jne abort
       cmp r8, -6
       jne abort
       cmp r9, -7
       jne abort
       cmp r10, -8
       jne abort
       cmp r11, -9
       jne abort
       cmp r13, -10
       jne abort
       cmp r14, -11
       jne abort
       cmp r15, -12
       jne abort
       mov rax, 0
       mov rdi, linea
       mov rsi, [dat1+r12*8]
       mov rdx, [dat2+r12*8]
       push rcx
       mov rcx, [result1+r12*8]
       mov r8,  [result2+r12*8]
       call printf

       pop rcx
       mov rax, -1
       mov rdi, -5
       mov rsi, -4
       mov rdx, -3
       mov r8,  -6
       mov r9,  -7
       mov r10, -8
       mov r11, -9
       inc r12

; ----- Opcion 1 -------------
;      loop again

; ----- Opcion 2 -------------
;       jmp salto
;back:  jmp again
;salto: loop back

; ----- Opcion 3 -------------
; es la mejor opcion porque es la que llama a "LAST" para terminar el programa
salto: loop next ; si el loop termino, salte a "last"
       jmp last  ; salte a LAST para llamar la salida del programa
next:  jmp again ; sino, repita el ciclo

last:
   mov   rax, 60   ; Call code for exit
   mov   rdi, 0    ; Exit program with success
   syscall

abort: mov   rax, 0
       mov   rdi, errmsg
       call  printf 
       mov   rax, 60   ; Call code for exit
       mov   rdi, 1    ; Exit with error
       syscall
