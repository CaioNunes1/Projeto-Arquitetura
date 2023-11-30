.data
str1: .asciiz "Teste Strings"
str2: .asciiz "Testando Strings em Mips"
buffer: .space 64

.text
main:
    # Teste a funcao strcpy
    la $a0, buffer
    la $a1, str1
    jal strcpy
    # Agora, buffer contem uma copia de str1

    # Teste a funcao memcpy
    la $a0, buffer
    la $a1, str2
    li $a2, 13
    jal memcpy
    # Agora, os primeiros 13 bytes de buffer contem uma copia de str2

    # Teste a funcao strcmp
    la $a0, str1
    la $a1, str2
    jal strcmp
    # O valor de retorno em $v0 indica se str1 eh igual, menor ou maior que str2

    # Termina o programa
    li $v0, 10
    syscall


# Funcao strcpy
strcpy:
    lbu $t0, 0($a1)       
    sb $t0, 0($a0)        
    beqz $t0, end_strcpy  # Se $t0 eh zero (NULL), entao termina
    addiu $a0, $a0, 1     
    addiu $a1, $a1, 1     
    j strcpy              # Vai para o proximo caractere
end_strcpy:
    jr $ra               

# Funcao memcpy
memcpy:
    beqz $a2, end_memcpy  # Se $a2 eh zero, entao termina
    lb $t0, 0($a1)        # Carrega o byte no endereco $a1 para $t0
    sb $t0, 0($a0)        # Armazena o byte de $t0 no endereco $a0
    addiu $a0, $a0, 1     
    addiu $a1, $a1, 1     
    addiu $a2, $a2, -1   
    j memcpy              # Vai para o proximo byte
end_memcpy:
    jr $ra                # Retorna para a funcao chamadora

# Funcao strcmp
strcmp:
    lbu $t0, 0($a0)       
    lbu $t1, 0($a1)       
    subu $v0, $t0, $t1    
    beqz $v0, next_char   # Se $v0 eh zero, entao vai para o proximo caractere
    jr $ra                # Retorna para a funcao chamadora
next_char:
    beqz $t0, end_strcmp  # Se $t0 eh zero (NULL), entao termina
    addiu $a0, $a0, 1    
    addiu $a1, $a1, 11
    j strcmp              # Vai para o proximo caractere
end_strcmp:
    jr $ra                # Retorna para a funcaoo chamadora
