    .data
destination: .asciiz "Bom dia"
source: .asciiz " Flor do dia"

    .text
    .globl main

main:
    la $a0, destination
    la $a1, source
    jal strcat
    move $a0, $v0
    li $v0, 4
    syscall
    li $v0, 10
    syscall

strcat:
    # Salva o endereço de início de destination em $t0
    move $t0, $a0

    # Encontra o final de destination
    loop1:
        lb $t1, 0($a0)
        beqz $t1, end_loop1
        addiu $a0, $a0, 1
        j loop1
    end_loop1:

    # Copia source para o final de destination
    loop2:
        lb $t1, 0($a1)
        beqz $t1, end_loop2
        sb $t1, 0($a0)
        addiu $a0, $a0, 1
        addiu $a1, $a1, 1
        j loop2
    end_loop2:

    # Adiciona o caractere NULL no final
    sb $zero, 0($a0)

    # Retorna o endereço de início de destination
    move $v0, $t0
    jr $ra
