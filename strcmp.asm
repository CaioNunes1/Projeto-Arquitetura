.data
prompt:     .asciiz     "Digite uma string ('.' ao final) > "
dot:        .asciiz     "."
eqmsg:      .asciiz     "strings sao iguais\n"
nemsg:      .asciiz     "strings nao sao iguais\n"

str1:       .space      80
str2:       .space      80

    .text

    .globl  main
main:
 # ler a primeira string
    la      $s2,str1
    move    $t2,$s2
    jal     getstr

    # ler a segunda string
    la      $s3,str2
    move    $t2,$s3
    jal     getstr

# loop de compara��o de strings (como strcmp)
cmploop:
    lb      $t2,($s2)                   # obtenha o pr�ximo caractere de str1
    lb      $t3,($s3)                   # obtenha o pr�ximo caractere de str2
    bne     $t2,$t3,cmpne               # eles s�o diferentes? se sim, voe

    beq     $t2,$zero,cmpeq             # no EOS? sim, voe (strings iguais)

    addi    $s2,$s2,1                   # aponte para o pr�ximo caractere
    addi    $s3,$s3,1                   # aponte para o pr�ximo caractere
    j       cmploop

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

    # devemos parar?
    la      $a0,dot                     # obtenha o endere�o da string dot
    lb      $a0,($a0)                   # obtenha o valor do ponto
    lb      $t2,($t2)                   # obtenha o primeiro caractere da string do usu�rio
    beq     $t2,$a0,exit                # igual? sim, saia do programa

    jr      $ra                         # retorne

# saia do programa
exit:
    li      $v0,10
    syscall
