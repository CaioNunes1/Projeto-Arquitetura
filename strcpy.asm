    .data
str1: .space 50  # Espaço reservado para a string de entrada
msg: .asciiz "A string copiada foi: "
empty: .asciiz " "

    .text
    .globl main

main:
    # Lê a string de entrada do usuário
    li $v0, 8
    la $a0, str1
    li $a1, 50
    syscall
    move $a1, $a0 # copia o valor de $a0 para $a1
    la $a0, empty  #limpa $a0 colocando uma string vazia
    
    
     li $v0, 4
 la $a0, msg
    syscall
    
    jal strcpy
    li $v0, 4
    syscall

    # Termina o programa
    li $v0, 10
    syscall

strcpy: sub $sp, $sp, 4
	sw $s0, 0($sp)
	add $s0, $zero, $zero
	L1: add $t1, $a1, $s0
	lb $t2, 0($t1)
	add $t3, $a0, $s0
	sb $t2, 0($t3)
	beq $t2, $zero, L2
	add $s0, $s0, 1
	j L1
	
	L2: lw $s0, 0($sp)
	add $sp, $sp, 4
	jr $ra
	
