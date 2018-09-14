; nasm -felf64 -DPETER bench.asm
; ld bench.o
; perf stat -r 10 ./a.out

BITS 64
DEFAULT REL

section .bss
align 64
bufdest:    resb 4096
bufsrc:     resb 4096

section .text
global _start
_start:
    lea        rdi, [bufdest]
    lea        rsi, [bufsrc]
    mov        ebp, 1000000000
    
align 32
.loop:
    
    
    ; You can insert one of these instructions at the top of the loop to inflict aditional penalty.
    ;add eax,eax
    ;lea eax, [rdi+64]
    ;imul eax, edi, 1234
    ;mov rax, qword [rdi+64]
    
    
%ifdef PETER
    movzx  eax, word [rdi]      
    mov    byte [rsi + 4], al
    mov    byte [rsi + 8], ah
%endif
     
%ifdef CLANG
    mov     al, byte [rdi]
    mov     byte [rsi + 4], al
    mov     al, byte [rdi + 1]
    mov     byte [rsi + 8], al
%endif
        
        
%ifdef GCC
    movzx   eax, byte [rdi]
    mov     byte [rsi + 4], al
    movzx   eax, byte [rdi+1]
    mov     byte [rsi + 8], al
%endif
    
    
%ifdef MSVC
    cmp     byte [rdi], 1
    sete    byte [rsi + 4]        
    movzx   eax, byte [rdi+1]
    mov     byte [rsi + 8], al 
%endif  
    
%ifdef ICC
    xor       eax, eax                                    
    cmp       byte [rdi], 1                            
    mov       dl, byte [1+rdi]                          
    sete      al                                           
    mov       byte [rsi + 4], al                        
    mov       byte [rsi + 8], dl
%endif

    dec ebp
    jg .loop
    
    xor edi,edi
    mov eax,231
    syscall
