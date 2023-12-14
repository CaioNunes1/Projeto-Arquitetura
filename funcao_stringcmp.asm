.data
prompt:     .asciiz     "Digite uma string ('.' ao final) > "
dot:        .asciiz     "."
eqmsg:      .asciiz     "strings sao iguais\n"
nemsg:      .asciiz     "strings nao sao iguais\n"

	Joao:.asciiz "Jo�o.\n"
	Luiz:.asciiz "Luiz\n"
	Gabriel:.asciiz "Gabriel\n"
	Carlos:.asciiz"Carlos\n"

	names:.word Joao,Luiz,Gabriel,Carlos#como se fosse um vetor
	iterator:.word 0

str1:       .space      80
str2:       .space      80

    .text

    .globl  main
main:
 # ler a primeira string
    la      $s2,str1
    move    $t2,$s2
    jal     getstr
    #quando ele sai de getstr o nome est� guardado em $t2




# loop de compara��o de strings (como strcmp)
cmploop:
    la $s3,names
    li $t4,3
    lw $t5,iterator
    bgt $t5,$t4,cmpne
    
    sll $t6,$t5,2#$t6=4i
    addu $t6,$t6,$s3

    
    lw $s0,0($t6)
    
    lb      $t2,($s2)                   # obtenha o pr�ximo caractere de str1
    lb      $t3,($s0)                   # obtenha o pr�ximo caractere dos nomes do vetor
    bne     $t2,$t3,pula_string               # eles s�o diferentes? se sim, voe

    beq     $t2,$t3,cmpeq             # no EOS? sim, voe (strings iguais)

    addi    $s2,$s2,1                   # aponte para o pr�ximo caractere
    addi    $s0,$s0,1                	# aponte para o pr�ximo caractere
    j       cmploop
    
    pula_string:
    addi $t5,$t5,1
    sw $t5,iterator
    lw $t5,iterator
    
    j cmploop

# as strings _n�o_ s�o iguais -- envie mensagem
cmpne:
    la      $a0,nemsg
    li      $v0,4
    syscall
    j       main

# as strings _s�o_ iguais -- envie mensagem
cmpeq:
    la      $a0,eqmsg
    li      $v0,4
    syscall
    j       main

# getstr -- solicite e leia a string do usu�rio
#
# argumentos:
#   t2 -- endere�o do buffer de string
getstr:
    # solicite ao usu�rio
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
