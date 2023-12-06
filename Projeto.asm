.data
MENU_PROMPT:   .asciiz "Escolha uma opção:\n1. Criar conta\n2. Saldo\n3. Depósito\n4. Saque\n5. Imprimir vetor\n6. Sair\nOpção: "
SALDO_MSG:     .asciiz "Seu saldo é: $"
DEPOSITO_MSG:  .asciiz "Digite o valor do depósito: $"
SAQUE_MSG:     .asciiz "Digite o valor do saque: $"
INVALID_MSG:   .asciiz "Opção inválida. Tente novamente.\n"
QUEBRA_LINHA:  .asciiz "\n"

msg_Pedir_Nome: .asciiz "Digite seu nome:\n"
nome: .space 40
cpf: .space 40
msg_Pedir_CPF: .asciiz "Digite o seu CPF (Somente números):\n"

# Adicione a variável para armazenar o número da conta atual
conta_atual: .word 10000
vetor_nomes_clientes: .space 52   # Espaço para armazenar até 50 clientes (cada cliente ocupa 4 posições)
vetor_numero_cliente:.space 52
vetor_cpf_cliente:.space 52
num_de_clientes:.word 2

CPF_MSG:.asciiz "CPF:"
NOME_MSG:.asciiz "Nome:"
NUM_CONTA_MSG:.asciiz "Número da conta:"


iterator:.word 0
.text
.globl main

main:
    j menu

menu:
    # Exibir o menu
    li $v0, 4
    la $a0, MENU_PROMPT
    syscall

    # Ler a opção do usuário
    li $v0, 5
    syscall
    move $t0, $v0

    # Executar a opção escolhida
    beq $t0, 1, criar_conta
    beq $t0, 2, consultar_saldo
    beq $t0, 3, realizar_deposito
    beq $t0, 4, realizar_saque
    beq $t0, 5, imprimir_vetor
    beq $t0, 6, sair
    j opcao_invalida

criar_conta:
	lw $t3,num_de_clientes#carregando o número de clientes disponíveis
	addi $t3,$t3,1
	sw $t3,num_de_clientes
	beq $t3,50,finalizar_programa#se o numero de clientes for igual a zero termina o programa
	
	# Incrementar o número da conta atual
    	lw $t1, conta_atual
    	addi $t1, $t1, 1
   	sw $t1, conta_atual
    	
    	lw $t1,conta_atual

    	# registrador do vetor de numero do cliente
	la $t4, vetor_numero_cliente

	# Armazenar o número da conta
	move $a0,$t1
	sw $a0, 0($t4)

	# Solicitar o nome do usuário
	li $v0, 4
	la $a0, msg_Pedir_Nome
	syscall
        # Ler o nome do usuário
        
	li $v0, 8
	la $a0, nome
   	la $a1, 40
    	syscall
    	
    	#registrador do vetor de nomes dos clientes
    	la $t5,vetor_nomes_clientes
    	# Armazenar o nome
	sw $a0, 0($t5)

	# Solicitar o CPF do usuário
	li $v0, 4
	la $a0, msg_Pedir_CPF
	syscall
	
	li $v0, 8
	la $a0, cpf
   	la $a1, 40
   	
   	#registrador para vetor_cpf_cliente
   	la $t6,vetor_cpf_cliente
   	sw $a0,0($t6)
    	syscall

    j finalizar_programa

imprimir_vetor:
	la $t4,vetor_nomes_clientes
	la $s4,vetor_numero_cliente
	la $s5,vetor_cpf_cliente
	lw $s1,iterator
	lw $s2,num_de_clientes
	
	la $s6,0
	
	###imprimindo vetor dos nomes dos clientes
	begin_loop_nomes:
	bge $s1,$s2,begin_loop_num_clintes
	sll $s3,$s1,2 #s3=4*i
	
	addu $s3,$s3,$t4#4i=4i+ local de memoria do array clientes ---> EX: 4+1000
	
	li $v0,4
	lw $a0,0($s3)
	beqz $a0,begin_loop_num_clintes
	syscall
	
	addi $s1,$s1,1
	j begin_loop_nomes
	
	# imprimindo vetor do número do cliente
	begin_loop_num_clintes:
 	# Usando $s6 para controlar o loop de impressão do número do cliente
    	bge $s6, $s2, begin_loop_vetor_cpf
    
    	sll $s7, $s6, 2  # t6 = 4 * i
    	addu $s7, $s7, $s4  # 4i = 4i + local de memoria do array clientes
    
    	lw $a0, 0($s7)
	beqz $a0,begin_loop_vetor_cpf
    
    	li $v0, 1
    	syscall
    
    	addi $s6, $s6, 1
    	j begin_loop_num_clintes

	# imprimindo vetor do cpf
	begin_loop_vetor_cpf:
    	 # Usando $s6 para controlar o loop de impressão do cpf
    	bge $s6, $s2, finalizar_programa
    
    	sll $s3, $s6, 2  # t6 = 4 * i
    	la $s7,0
    	addu $s7, $s7, $s5  # 4i = 4i + local de memoria do array clientes
    
    	lw $a0, 0($s3)
    	beqz $a0, finalizar_programa
    
    	li $v0, 1
    	syscall
    
    	addi $s6, $s6, 1
    	j begin_loop_vetor_cpf

	j finalizar_programa

consultar_saldo:
    # Lógica para consultar o saldo
    # (substitua por sua implementação)
    j menu

realizar_deposito:
    # Lógica para realizar um depósito
    # (substitua por sua implementação)
    j menu

realizar_saque:
    # Lógica para realizar um saque
    # (substitua por sua implementação)
    j menu

sair:
    # Lógica para encerrar o programa
    # (substitua por sua implementação)
    li $v0, 10
    syscall

opcao_invalida:
    # Mensagem para opção inválida
    li $v0, 4
    la $a0, INVALID_MSG
    syscall

    j menu

finalizar_programa:
    j menu
