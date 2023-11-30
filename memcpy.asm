    .data
src: .byte 1, 2, 3, 4, 5, 6, 7, 8, 9, 0  # Array de origem
dst: .space 10                            # Espa�o reservado para o array de destino
len: .word 10                             # Tamanho dos arrays

    .text
    .globl main

main:
    la $a0, dst  # Carrega o endere�o de dst em $a0
    la $a1, src  # Carrega o endere�o de src em $a1
    lw $a2, len  # Carrega o valor de len em $a2
    jal memcpy   # Chama a fun��o memcpy

    # Imprime o array copiado
    la $a1, dst  # Carrega o endere�o de dst em $a1
    lw $a2, len  # Carrega o valor de len em $a2
    print_loop:
        lb $a0, 0($a1)  # Carrega o byte atual do array
        li $v0, 1
        syscall         # Imprime o byte
        addiu $a1, $a1, 1
        addiu $a2, $a2, -1
        bnez $a2, print_loop  # Se ainda h� bytes para imprimir, continua o loop

    # Termina o programa
    li $v0, 10
    syscall

memcpy:
    # Copia o array
    loop:
        lb $t0, 0($a1)  # Carrega o byte atual do array de origem
        sb $t0, 0($a0)  # Armazena o byte no array de destino
        addiu $a0, $a0, 1
        addiu $a1, $a1, 1
        addiu $a2, $a2, -1
        bnez $a2, loop  # Se ainda h� bytes para copiar, continua o loop

    # Retorna o endere�o do array de destino
    jr $ra
