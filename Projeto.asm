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
vetor_nomes_clientes: .space 200   # Espaço para armazenar até 50 clientes (cada cliente ocupa 4 posições)
vetor_numero_cliente: .space 200
vetor_cpf_cliente: .space 200
vetor_saldo_cliente: .space 200
vetor_credito_cliente: .space 200
num_de_clientes: .word 0

# Vetores para guardar dados de transações de debito
vetor_conta_origem_debito: .space 200
vetor_conta_destino_debito: .space 200
vetor_valor_trasacao_debito: .space 200
vetor_data_transacao_debito: .space 200
num_de_transacoes_debito: .word 0

# Vetores para guardar dados de transações de credito
vetor_conta_origem_credito: .space 200
vetor_conta_destino_credito: .space 200
vetor_valor_trasacao_credito: .space 200
vetor_data_transacao_credito: .space 200
num_de_transacoes_credito: .word 0

msg_cpf_ja_existente:.asciiz "Impossível criar conta, esse cpf já foi cadastrado!"


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
    beq $t0, 6, imprimir_trasacoes_debito
    beq $t0, 7, imprimir_transacoes_credito
    beq $t0, 8, sair
    j opcao_invalida

criar_conta:
	lw $t3,num_de_clientes #carregando o número de clientes disponíveis
	li $t7,4 #guardando para poder servir de iterador quando for ir criando usuários
	mul $t7,$t7,$t3 #fazendo $t7= 4*i para guardar corretamente os valores na posição do vetor
	addi $t3,$t3,1
	sw $t3,num_de_clientes
	beq $t3,50,finalizar_programa #se o numero de clientes for igual a zero termina o programa
	
	# Incrementar o número da conta atual
    	lw $t1, conta_atual
    	addi $t1, $t1, 1
   	sw $t1, conta_atual
    	
    	lw $t1,conta_atual

    	# registrador do vetor de numero do cliente
	la $t4, vetor_numero_cliente


    	add $t4, $t4, $t7  # $t4 agora contém o endereço desejado
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
    	add $t5,$t5,$t7# $t5 agora contém o endereço desejado
    	# Armazenar o nome
	sw $a0, 0($t5)#ajeitando e a cada iteração colocando na posição 4i

	# Solicitar o CPF do usuário
	li $v0, 4
	la $a0, msg_Pedir_CPF
	syscall
	
	li $v0, 8
	la $a0, cpf
   	la $a1, 40
   	syscall
   	
   	##verificar se o cpf já existe
   	jal verifica_cpf
   	continua:
   	
   	#colocando denovo o valor de $t7 para ser um multiplo de 4=4i, pois ele mudou de valor quando ele foi para
   	# a função verifica_cpf
   	move $t3,$zero
   	lw $t3,num_de_clientes
   	la $a0,cpf
   	subi $t3,$t3,1
   	li $t7,4
   	mul $t7,$t7,$t3
   	
   	#registrador para vetor_cpf_cliente
   	la $t6,vetor_cpf_cliente
   	add $t6,$t6,$t7#ajeitando e a cada iteração colocando na posição 4i
   	sw $a0,0($t6)


    j finalizar_programa

imprimir_vetor:
	la $t4,vetor_nomes_clientes
	la $s4,vetor_numero_cliente
	la $s5,vetor_cpf_cliente
	lw $s1,iterator
	lw $s2,num_de_clientes
	
	la $s6,0#reg para acessar as posições do vetor
	li $t9,0
	
	###imprimindo vetor dos nomes dos clientes
	begin_loop_nomes:
    	#jal pula_linha
    	
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
    
    	sll $s7, $s6, 2  # t7 = 4 * i
    	addu $s7, $s7, $s4  # 4i = 4i + local de memoria do array clientes
    
	
	li $v0, 1#imprimindo num do cliente
    	lw $a0, 0($s7)#$a0 acessa a posição 4i do vetor do num de clientes, as posições do vetor só são acessadas de 4 em 4

	beqz $a0,begin_loop_vetor_cpf
    	syscall
    
    	addi $s6, $s6, 1
    	j begin_loop_num_clintes

	# imprimindo vetor do cpf
	begin_loop_vetor_cpf:
    	# Usando $t9 para controlar o loop de impressão do cpf
    	bge $t9, $s2, finalizar_programa
    
    	sll $t8, $t9, 2  # t8 = 4 * i
    	addu $t8, $t8, $s5  # 4i = 4i + local de memoria do array clientes
    	
    	#pulando linha
	jal pula_linha
    	
	li $v0, 4
    	lw $a0, 0($t8)
    	beqz $a0, finalizar_programa
    
    	syscall
    
    	addi $t9, $t9, 1
    	j begin_loop_vetor_cpf

	j finalizar_programa

imprimir_trasacoes_debito:
	# -----------------------------------------------------------------------------------
	# Função que imprime todas as transações de débito de um cliente através do seu CPF

	# Variáveis
		# $a0: guarda o CPF digitado
		# $t1: tamanho do vetor de transações
		# $t2: índice de controle do laço
		# $t3: retorno da função strcmp
	# -----------------------------------------------------------------------------------

	# Solicitar o CPF do usuário
	li $v0, 4
	la $a0, msg_Pedir_CPF
	syscall
	
	li $v0, 8
	la $a0, cpf
   	la $a1, 40
   	syscall
   	
	lw $t1, num_de_transacoes_debito # carregando o numero de transações de débito feitas
	li $t2, 0 # inicializando indice do loop
	inicio_loop_trasacoes_debito:
		bge $t2, $t1, fim_loop_trasacoes_debito # verificando a condição do loop
		j strcmp # comparando o CPF digitado com os CPF's de cada transação
		beq $t3, $zero, imprimir_trasacao_debito # Comparando o retorno da strcmp e imprimindo cada transação caso os CPF's deem match
		addi $t2, $t2, 1 # incrementando a variável de controle
		j inicio_loop_trasacoes_debito # volta para o início do loop para verificar condição de parada
	fim_loop_trasacoes_debito:
		j menu # volta para o menu
	
imprimir_trasacao_debito:
	# -----------------------------------------------------------------------------------
	# Função que imprime uma transação de débito
	# -----------------------------------------------------------------------------------
	
imprimir_trasacoes_credito:
	# -----------------------------------------------------------------------------------
	# Função que imprime todas as transações de crédito de um cliente através do seu CPF

	# Variáveis
		# $a0: guarda o CPF digitado
		# $t1: tamanho do vetor de transações
		# $t2: índice de controle do laço
		# $t3: retorno da função strcmp
	# -----------------------------------------------------------------------------------
	
	# Solicitar o CPF do usuário
	li $v0, 4
	la $a0, msg_Pedir_CPF
	syscall
	
	li $v0, 8
	la $a0, cpf
   	la $a1, 40
   	syscall
   	
	lw $t1, num_de_transacoes_credito # carregando o numero de transações de débito feitas
	li $t2, 0 # inicializando indice do loop
	inicio_loop_trasacoes_credito:
		bge $t2, $t1, fim_loop_trasacoes_credito # verificando a condição do loop
		j strcmp # comparando o CPF digitado com os CPF's de cada transação
		beq $t3, $zero, imprimir_trasacao_credito # Comparando o retorno da strcmp e imprimindo cada transação caso os CPF's deem match
		addi $t2, $t2, 1 # incrementando a variável de controle
		j inicio_loop_trasacoes_credito # volta para o início do loop para verificar condição de parada
	fim_loop_trasacoes_credito:
		j menu # volta para o menu

imprimir_trasacao_credito:
	# -----------------------------------------------------------------------------------
	# Função que imprime uma transação de crédito
	# -----------------------------------------------------------------------------------
	
strcmp:
	# -----------------------------------------------------------------------------------
	# Função que compara duas strings
		
	#Parametros:
		# Str1 -> $a0(CPF que foi digitado)
		# Str2 -> vetor_conta_origem_debito[$t2](CPF de origem da transação atual do loop)
	#Retorno da função no deve ser colocado no $t3
		# 0 caso as strings sejam iguais
		# negativo se a primeira for menor que a segunda
		# positivo se a primeira for maior que a segunda
	# -----------------------------------------------------------------------------------


pula_linha:
	li $v0,4
	la $a0,QUEBRA_LINHA
	syscall
	jr $ra		
			
verifica_cpf:
	#pega o cpf e move para $t0
	move $t0,$a0
	
	li $t1,0
	lw $t2,num_de_clientes
	la $s1,vetor_cpf_cliente
	
	loop_verifica:
	beq $t1,$t2,continua
	sll $t3,$t1,2 #$t3=4i
	
	addu $t3,$t3,$s1
	
	lw $a0,0($t3)
	
	beq $t0,$a0,cpf_ja_existente
	addi $t1,$t1,1
	j loop_verifica
	
	
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
    
    cpf_ja_existente:
    # Mensagem para opção inválida
    li $v0, 4
    la $a0,msg_cpf_ja_existente
    syscall

    jal continua

finalizar_programa:
    j menu