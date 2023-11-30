.data
DISPLAY_ADDR:   .word 0xffff000c   # Endereço do display MMIO
KEYBOARD_ADDR:  .word 0xffff0004   # Endereço do teclado MMIO
DELAY:          .word 100000      # Valor para controlar o atraso

.text
.globl main

main:
    j loop

loop:
    # Aguardar até que um caractere seja digitado no teclado
    lw $t1, KEYBOARD_ADDR
    lw $t2, 0($t1)      # Carregar o caractere do teclado

    # Verificar se o caractere é diferente do último lido
    beq $t2, $t3, delay_loop  # Se for igual, continue no loop

    # Transmitir o caractere para o display
    lw $t1, DISPLAY_ADDR
    sw $t2, 0($t1)      # Transmitir o caractere para o display

    # Atualizar o último caractere lido
    move $t3, $t2

delay_loop:
    # Aguardar um curto período de tempo (atraso)
    lw $t4, DELAY
delay_loop_inner:
    addi $t4, $t4, -1
    bnez $t4, delay_loop_inner

    j loop              # Continue no loop principal
