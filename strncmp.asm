    .data
str1: .asciiz "Great"
str2: .asciiz "Gre"
num:  .word 3
msg1: .asciiz "As substrings são iguais.\n"
msg2: .asciiz "As substrings são diferentes.\n"

    .text
    .globl main

main:
    # Carregando endereços das strings e o número de caracteres para comparar
    la $a0, str1
    la $a1, str2
    lw $a2, num

    # Chamando a função strncmp
    jal strncmp

    # Verificando o resultado da comparação
    beqz $v0, equal

    # Se o resultado for diferente de zero, imprime a mensagem
    la $a0, msg2
    j print

equal:
    # Se o resultado for igual a zero, imprime a mensagem
    la $a0, msg1

print:
    li $v0, 4
    syscall

    # Finalizando o programa
    li $v0, 10
    syscall



strncmp:
    # Inicializando $t0 com zero para o loop
    add $t0, $zero, $zero

loop:
    # Carregando caracteres das strings
    lb $t1, 0($a0)
    lb $t2, 0($a1)

    # Comparando caracteres
    sub $t3, $t1, $t2
    bnez $t3, exit

    # Verificando se atingimos o final das strings
    beqz $t1, exit
    beqz $t2, exit

    # Incrementando os ponteiros das strings
    addi $a0, $a0, 1
    addi $a1, $a1, 1

    # Incrementando o contador do loop
    addi $t0, $t0, 1

    # Verificando se atingimos o limite 'num'
    slt $t4, $t0, $a2
    bnez $t4, loop

exit:
    # Retornando a diferença entre os caracteres
    add $v0, $t3, $zero
    jr $ra
