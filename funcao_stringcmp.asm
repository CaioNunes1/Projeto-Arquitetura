.data
prompt:     .asciiz     "Digite uma string:"
dot:        .asciiz     "."
eqmsg:      .asciiz     "strings sao iguais\n"
nemsg:      .asciiz     "strings nao sao iguais\n"
msg_fora_range:.asciiz "fora de range\n"
msg_pula_string:.asciiz "pulou de string\n"
msg_pulou_carac:.asciiz "pulou o caracter\n"
	Joao:.asciiz "João.\n"
	Luiz:.asciiz "Luiz\n"
	Gabriel:.asciiz "Gabriel\n"
	Carlos:.asciiz"Carlos\n"

	names:.word Joao,Luiz,Gabriel,Carlos#como se fosse um vetor
	iterator2:.word 0

str1:       .space      80
str2:       .space      80

    .text

    .globl  main_funcao
main_funcao:
 # ler a primeira string
    la      $s2,str1
    move    $t2,$s2
    jal     getstr
    #quando ele sai de getstr o nome está guardado em $t2


# loop de comparação de strings (como strcmp)
cmploop:
    la $s3,names
    li $t4,3
    lw $t5,iterator2
    bgt $t5,3,reseta_vetor
    
    
    
    sll $t6,$t5,2#$t6=4i
    addu $t6,$t6,$s3

    
    lw $s0,0($t6)
    continua_funcao:
    
    
    lb      $t2,($s2)                   # obtenha o próximo caractere de str1
    lb      $t3,($s0)                   # obtenha o próximo caractere dos nomes do vetor
    
    bne $t2, $t3, pula_string           # se são diferentes, pula para pula_string
    beq $t3, $zero, cmpeq               # quando chegar no caractere nulo, pula para cmpeq
    beq $t3,$t2,pula_caracter

    

    j continua_funcao                          # se os caracteres são iguais, continue para o próximo    
    
    j cmploop
    
    pula_string:
    addi $t5,$t5,1
    sw $t5,iterator2

    li $v0,4
    la $a0,msg_pula_string
    syscall
    
    j cmploop
    
    reseta_vetor:
    li $t5,0
    sw $t5,iterator2
    j main_funcao
    
    pula_caracter:
    addi    $s2,$s2,1                   # aponte para o próximo caractere
    addi    $s0,$s0,1                	# aponte para o próximo caractere
    
    li $v0,4
    la $a0,msg_pulou_carac
    syscall
    jal continua_funcao
    
# as strings _não_ são iguais -- envie mensagem
cmpne:
    la      $a0,nemsg
    li      $v0,4
    syscall
    j       exit

# as strings _são_ iguais -- envie mensagem
cmpeq:
    la      $a0,eqmsg
    li      $v0,4
    syscall
    j       main_funcao

fora_de_range:
	li $v0,4
	la $a0,msg_fora_range
	syscall
# getstr -- solicite e leia a string do usuário
#
# argumentos:
#   t2 -- endereço do buffer de string
getstr:
    # solicite ao usuário
    la      $a0,prompt
    li      $v0,4
    syscall

    # leia a string
    move    $a0,$t2
    li      $a1,79
    li      $v0,8
    syscall

    jr      $ra

# saia do programa
exit:
    li      $v0,10
    syscall
