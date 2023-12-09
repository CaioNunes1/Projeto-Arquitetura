.data
MENU_PROMPT:   .asciiz "Escolha uma opÃ§Ã£o:\n1. Criar conta\n2. Saldo\n3. DepÃ³sito\n4. Saque\n5. Imprimir vetor\n6. Sair\nOpÃ§Ã£o: "
SALDO_MSG:     .asciiz "Seu saldo Ã©: $"
DEPOSITO_MSG:  .asciiz "Digite o valor do depÃ³sito: $"
SAQUE_MSG:     .asciiz "Digite o valor do saque: $"
INVALID_MSG:   .asciiz "OpÃ§Ã£o invÃ¡lida. Tente novamente.\n"
QUEBRA_LINHA:  .asciiz "\n"

msg_Pedir_Nome: .asciiz "Digite seu nome:\n"
nome: .space 40
cpf: .space 40
msg_Pedir_CPF: .asciiz "Digite o seu CPF (Somente nÃºmeros):\n"

# Adicione a variÃ¡vel para armazenar o nÃºmero da conta atual
conta_atual: .word 10000
vetor_nomes_clientes: .space 200   # Espaco para armazenar ate 50 clientes (cada cliente ocupa 4 posiÃ§Ãµes)
vetor_numero_cliente: .space 200
vetor_cpf_cliente: .space 200
vetor_saldo_cliente: .space 200
vetor_credito_cliente: .space 200
num_de_clientes: .word 0

# Vetores para guardar dados de transaÃ§Ãµes de debito
vetor_conta_origem_debito: .space 1000
vetor_conta_destino_debito: .space 1000
vetor_valor_trasacao_debito: .space 1000
vetor_data_transacao_debito: .space 1000
num_de_transacoes_debito: .word 0

# Vetores para guardar dados de transaÃ§Ãµes de credito
vetor_conta_origem_credito: .space 1000
vetor_conta_destino_credito: .space 1000
vetor_valor_trasacao_credito: .space 1000
vetor_data_transacao_credito: .space 1000
num_de_transacoes_credito: .word 0

msg_cpf_ja_existente:.asciiz "ImpossÃ­vel criar conta, esse cpf jÃ¡ foi cadastrado!"


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

    # Ler a opÃ§Ã£o do usuÃ¡rio
    li $v0, 5
    syscall
    move $t0, $v0

    # Executar a opÃ§Ã£o escolhida
    beq $t0, 1, criar_conta
    beq $t0, 2, consultar_saldo
    beq $t0, 3, realizar_deposito
    beq $t0, 4, realizar_saque
    beq $t0, 5, imprimir_vetor # apenas de teste
    beq $t0, 6, imprimir_trasacoes_debito
    beq $t0, 7, imprimir_transacoes_credito
    beq $t0, 8, sair
    j opcao_invalida

# --------------------------------------------------------------------------------
# Opção 1 do menu
# --------------------------------------------------------------------------------
criar_conta:
	lw $t3,num_de_clientes #carregando o nÃºmero de clientes disponÃ­veis
	li $t7,4 #guardando para poder servir de iterador quando for ir criando usuÃ¡rios
	mul $t7,$t7,$t3 #fazendo $t7= 4*i para guardar corretamente os valores na posiÃ§Ã£o do vetor
	addi $t3,$t3,1
	sw $t3,num_de_clientes
	beq $t3,50,menu #se o numero de clientes for igual a zero termina o programa
	
	# Incrementar o nÃºmero da conta atual
    	lw $t1, conta_atual
    	addi $t1, $t1, 1
   	sw $t1, conta_atual
    	
    	lw $t1,conta_atual

    	# registrador do vetor de numero do cliente
	la $t4, vetor_numero_cliente


    	add $t4, $t4, $t7  # $t4 agora contÃ©m o endereÃ§o desejado
	# Armazenar o nÃºmero da conta
	move $a0,$t1
	sw $a0, 0($t4)

	# Solicitar o nome do usuÃ¡rio
	li $v0, 4
	la $a0, msg_Pedir_Nome
	syscall
        # Ler o nome do usuÃ¡rio
        
	li $v0, 8
	la $a0, nome
   	la $a1, 40
    	syscall
    	
    	#registrador do vetor de nomes dos clientes
    	la $t5,vetor_nomes_clientes
    	add $t5,$t5,$t7# $t5 agora contÃ©m o endereÃ§o desejado
    	# Armazenar o nome
	sw $a0, 0($t5)#ajeitando e a cada iteraÃ§Ã£o colocando na posiÃ§Ã£o 4i

	# Solicitar o CPF do usuÃ¡rio
	li $v0, 4
	la $a0, msg_Pedir_CPF
	syscall
	
	li $v0, 8
	la $a0, cpf
   	la $a1, 40
   	syscall
   	
   	##verificar se o cpf jÃ¡ existe
   	jal verifica_cpf
   	continua:
   	
   	#colocando denovo o valor de $t7 para ser um multiplo de 4=4i, pois ele mudou de valor quando ele foi para
   	# a funÃ§Ã£o verifica_cpf
   	move $t3,$zero
   	lw $t3,num_de_clientes
   	la $a0,cpf
   	subi $t3,$t3,1
   	li $t7,4
   	mul $t7,$t7,$t3
   	
   	#registrador para vetor_cpf_cliente
   	la $t6,vetor_cpf_cliente
   	add $t6,$t6,$t7#ajeitando e a cada iteraÃ§Ã£o colocando na posiÃ§Ã£o 4i
   	sw $a0,0($t6)


    j menu

# --------------------------------------------------------------------------------
# Opção 2 do menu
# --------------------------------------------------------------------------------
consultar_saldo:
    # LÃ³gica para consultar o saldo
    # (substitua por sua implementaÃ§Ã£o)
    j menu

# --------------------------------------------------------------------------------
# Opção 3 do menu
# --------------------------------------------------------------------------------
realizar_deposito:
    # LÃ³gica para realizar um depÃ³sito
    # (substitua por sua implementaÃ§Ã£o)
    j menu

# --------------------------------------------------------------------------------
# Opção 4 do menu
# --------------------------------------------------------------------------------
realizar_saque:
    # LÃ³gica para realizar um saque
    # (substitua por sua implementaÃ§Ã£o)
    j menu

# --------------------------------------------------------------------------------
# Opção 5 do menu
# --------------------------------------------------------------------------------
imprimir_vetor:
	la $t4,vetor_nomes_clientes
	la $s4,vetor_numero_cliente
	la $s5,vetor_cpf_cliente
	lw $s1,iterator
	lw $s2,num_de_clientes
	
	la $s6,0#reg para acessar as posiÃ§Ãµes do vetor
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
	
	# imprimindo vetor do nÃºmero do cliente
	begin_loop_num_clintes:
 	# Usando $s6 para controlar o loop de impressÃ£o do nÃºmero do cliente
    	bge $s6, $s2, begin_loop_vetor_cpf
    
    	sll $s7, $s6, 2  # t7 = 4 * i
    	addu $s7, $s7, $s4  # 4i = 4i + local de memoria do array clientes
    
	
	li $v0, 1 #imprimindo num do cliente
    	lw $a0, 0($s7) #$a0 acessa a posicao 4i do vetor do num de clientes, as posicoes do vetor sÃ³ sÃ£o acessadas de 4 em 4

	beqz $a0,begin_loop_vetor_cpf
    	syscall
    
    	addi $s6, $s6, 1
    	j begin_loop_num_clintes

	# imprimindo vetor do cpf
	begin_loop_vetor_cpf:
    	# Usando $t9 para controlar o loop de impressao do cpf
    	bge $t9, $s2, menu
    
    	sll $t8, $t9, 2  # t8 = 4 * i
    	addu $t8, $t8, $s5  # 4i = 4i + local de memoria do array clientes
    	
    	#pulando linha
	jal pula_linha
    	
	li $v0, 4
    	lw $a0, 0($t8)
    	beqz $a0, menu
    
    	syscall
    
    	addi $t9, $t9, 1
    	j begin_loop_vetor_cpf

	j menu

# --------------------------------------------------------------------------------
# Opção 6 do menu
# --------------------------------------------------------------------------------
imprimir_trasacoes_debito:
	# -----------------------------------------------------------------------------------
	# Funcao que imprime todas as transacoes de debito de um cliente atraves do seu CPF

	# Variaveis
		# $a0: guarda o CPF digitado
		# $t1: tamanho do vetor de transacoes
		# $t2: Indice de controle do laco
		# $t3: retorno da funÃ§Ã£o strcmp
	# -----------------------------------------------------------------------------------

	# Solicitar o CPF do usuÃ¡rio
	li $v0, 4
	la $a0, msg_Pedir_CPF
	syscall
	
	li $v0, 8
	la $a0, cpf
   	la $a1, 40
   	syscall
   	
	lw $t1, num_de_transacoes_debito # carregando o numero de transacoes de debito feitas
	li $t2, 0 # inicializando indice do loop
	inicio_loop_trasacoes_debito:
		bge $t2, $t1, fim_loop_trasacoes_debito # verificando a condicao do loop
		j strcmp # comparando o CPF digitado com os CPF's de cada transacao
		beq $t3, $zero, imprimir_trasacao_debito # Comparando o retorno da strcmp e imprimindo cada transacao caso os CPF's deem match
		continua_loop_trasacoes_debito:
		addi $t2, $t2, 1 # incrementando a variavel de controle
		j inicio_loop_trasacoes_debito # volta para o inicio do loop para verificar condicao de parada
	fim_loop_trasacoes_debito:
		j menu # volta para o menu
	
imprimir_trasacao_debito:
	# -----------------------------------------------------------------------------------
	# FunÃ§Ã£o que imprime uma transaÃ§Ã£o de dÃ©bito
	# -----------------------------------------------------------------------------------
	
	# Carregando os vetores de interesse
	la $s1, vetor_conta_origem_debito
	la $s2, vetor_conta_destino_debito
	la $s3, vetor_valor_trasacao_debito
	la $s4, vetor_data_transacao_debito
	
	move $t4, $t2 # guardando em $t4 o índice dos dados que queremos imprimir
	sll $t4, $t4, 2 # $t4 = $t4 * 4(calculando o deslocamento)
	
	addu $s1, $s1, $t4 # somando o deslocamento com a base do vetor
	lw $s5, 0($s1)
	li $v0, 1
    	move $a0, $s5      
    	syscall
    	
    	addu $s2, $s2, $t4 # somando o deslocamento com a base do vetor
	lw $s5, 0($s2)
	li $v0, 1
    	move $a0, $s5      
    	syscall
    	
    	addu $s3, $s3, $t4 # somando o deslocamento com a base do vetor
	lw $s5, 0($s3)
	li $v0, 1
    	move $a0, $s5      
    	syscall
    	
    	addu $s4, $s4, $t4 # somando o deslocamento com a base do vetor
	lw $s5, 0($s4)
	li $v0, 1
    	move $a0, $s5      
    	syscall
    	
    	j continua_loop_trasacoes_debito

# --------------------------------------------------------------------------------
# Opção 7 do menu
# --------------------------------------------------------------------------------
imprimir_trasacoes_credito:
	# -----------------------------------------------------------------------------------
	# Funcao que imprime todas as transacoes de credito de um cliente atraves do seu CPF

	# Variaveis
		# $a0: guarda o CPF digitado
		# $t1: tamanho do vetor de transacoes
		# $t2: Indice de controle do laco
		# $t3: retorno da funcao strcmp
	# -----------------------------------------------------------------------------------
	
	# Solicitar o CPF do usuario
	li $v0, 4
	la $a0, msg_Pedir_CPF
	syscall
	
	li $v0, 8
	la $a0, cpf
   	la $a1, 40
   	syscall
   	
	lw $t1, num_de_transacoes_credito # carregando o numero de transacoess de debito feitas
	li $t2, 0 # inicializando indice do loop
	inicio_loop_trasacoes_credito:
		bge $t2, $t1, fim_loop_trasacoes_credito # verificando a condicao do loop
		j strcmp # comparando o CPF digitado com os CPF's de cada transacao
		beq $t3, $zero, imprimir_trasacao_credito # Comparando o retorno da strcmp e imprimindo cada transacao caso os CPF's deem match
		continua_loop_trasacoes_credito:
		addi $t2, $t2, 1 # incrementando a variavel de controle
		j inicio_loop_trasacoes_credito # volta para o inicio do loop para verificar condicao de parada
	fim_loop_trasacoes_credito:
		j menu # volta para o menu

imprimir_trasacao_credito:
	# -----------------------------------------------------------------------------------
	# Funcao que imprime uma transacao de credito
	# -----------------------------------------------------------------------------------
	
	# Carregando os vetores de interesse
	la $s1, vetor_conta_origem_credito
	la $s2, vetor_conta_destino_credito
	la $s3, vetor_valor_trasacao_credito
	la $s4, vetor_data_transacao_credito
	
	move $t4, $t2 # guardando em $t4 o indice dos dados que queremos imprimir
	sll $t4, $t4, 2 # $t4 = $t4 * 4(calculando o deslocamento)
	
	addu $s1, $s1, $t4 # somando o deslocamento com a base do vetor
	lw $s5, 0($s1)
	li $v0, 1
    	move $a0, $s5      
    	syscall
    	
    	addu $s2, $s2, $t4 # somando o deslocamento com a base do vetor
	lw $s5, 0($s2)
	li $v0, 1
    	move $a0, $s5      
    	syscall
    	
    	addu $s3, $s3, $t4 # somando o deslocamento com a base do vetor
	lw $s5, 0($s3)
	li $v0, 1
    	move $a0, $s5      
    	syscall
    	
    	addu $s4, $s4, $t4 # somando o deslocamento com a base do vetor
	lw $s5, 0($s4)
	li $v0, 1
    	move $a0, $s5      
    	syscall
    	
    	j continua_loop_trasacoes_credito
    	
# --------------------------------------------------------------------------------
# Funções de setar o as posições não ocupadas dos vetor de saldo do cliente
# --------------------------------------------------------------------------------
setar_valores_vetor_de_saldo_dos_clientes:
	li $s0,0#ser o iterador do loop
	la $t0,vetor_saldo_cliente #reg para guardar o vetor de saldo dos clientes
	
	begin_loop_vetor_saldo:
	bgt $s0,50,finalizar_programa#se $s0 for maior que 50
	sll $s2,$s0,2 # $s2 = 4i
	
	addu $s2,$s2,$t0 #4i=4i+ local de memoria do array saldo dos clientes ---> EX: 4+1000
	lw $a0,0($s2)#recebendo em $a0 o valor da posição do array 0,4,8

	#se o valor da posição 4i for maior que zero, pula a posição
	addi $s0,$s0,1#somando o valor do iterador
	bgtz $a0,begin_loop_vetor_saldo
	
	#se o valor não for maior que zero
	li $a0,0 #seta aquela posição com valor igual a 0
	sw $a0,0($t0)
	
	j begin_loop_vetor_saldo
# --------------------------------------------------------------------------------
# Funções de setar o as posições não ocupadas do vetor de credito do cliente
# --------------------------------------------------------------------------------
setar_valores_vetor_de_credito_dos_clientes:
	li $s0,0#ser o iterador do loop
	la $t0,vetor_credito_cliente #reg para guardar o vetor de saldo dos clientes
	
	begin_loop_vetor_credito:
	bgt $s0,50,finalizar_programa#se $s0 for maior que 50
	sll $s2,$s0,2 # $s2 = 4i
	
	addu $s2,$s2,$t0 #4i=4i+ local de memoria do array saldo dos clientes ---> EX: 4+1000
	lw $a0,0($s2)#recebendo em $a0 o valor da posição do array 0,4,8

	#se o valor da posição 4i for maior que zero, pula a posição
	addi $s0,$s0,1#somando o valor do iterador
	bgtz $a0,begin_loop_vetor_credito
	
	#se o valor da posição não for maior que zero
	li $a0,1500 #seta aquela posição com valor igual a 1500
	sw $a0,0($t0)
	
	j begin_loop_vetor_credito
	
# --------------------------------------------------------------------------------
# Funções de setar o as posições não ocupadas do vetor de nomes dos clientes
# --------------------------------------------------------------------------------
setar_valores_vetor_de_nomes_dos_clientes:
	li $s0,0#ser o iterador do loop
	la $t0,vetor_nomes_clientes #reg para guardar o vetor de saldo dos clientes
	
	begin_loop_vetor_nomes:
	bgt $s0,50,finalizar_programa#se $s0 for maior que 50
	sll $s2,$s0,2 # $s2 = 4i
	
	addu $s2,$s2,$t0 #4i=4i+ local de memoria do array saldo dos clientes ---> EX: 4+1000
	lb $a0,0($s2)# recebendo em $a0 o valor da posição do array (um caractere)

	#se o valor da posição 4i for maior que zero, pula a posição
	addi $s0,$s0,1#somando o valor do iterador
	bgtz $a0,begin_loop_vetor_nomes
	
	#se o valor da posição não for maior que zero
	li $a0,0 #seta aquela posição com valor igual a 1500
	sb $a0,0($t0)
	
	j begin_loop_vetor_nomes
	
# --------------------------------------------------------------------------------
# Funções de setar o as posições não ocupadas do vetor de cpf dos clientes
# --------------------------------------------------------------------------------
setar_valores_vetor_de_cpf_dos_clientes:
	li $s0,0#ser o iterador do loop
	la $t0,vetor_cpf_cliente #reg para guardar o vetor de saldo dos clientes
	
	begin_loop_vetor_cpf:
	bgt $s0,50,finalizar_programa#se $s0 for maior que 50
	sll $s2,$s0,2 # $s2 = 4i
	
	addu $s2,$s2,$t0 #4i=4i+ local de memoria do array saldo dos clientes ---> EX: 4+1000
	lb $a0,0($s2)# recebendo em $a0 o valor da posição do array (um caractere)

	#se o valor da posição 4i for maior que zero, pula a posição
	addi $s0,$s0,1#somando o valor do iterador
	bgtz $a0,begin_loop_vetor_cpf
	
	#se o valor da posição não for maior que zero
	li $a0,0 #seta aquela posição com valor igual a 1500
	sb $a0,0($t0)
	
	j begin_loop_vetor_cpf
	
# --------------------------------------------------------------------------------
# Funções de setar o as posições não ocupadas do vetor de numero do cliente
# --------------------------------------------------------------------------------
setar_valores_vetor_de_numero_da_conta_dos_clientes:
	li $s0,0#ser o iterador do loop
	la $t0,vetor_numero_cliente #reg para guardar o vetor de saldo dos clientes
	
	begin_loop_vetor_num_do_cliente:
	bgt $s0,50,finalizar_programa#se $s0 for maior que 50
	sll $s2,$s0,2 # $s2 = 4i
	
	addu $s2,$s2,$t0 #4i=4i+ local de memoria do array saldo dos clientes ---> EX: 4+1000
	lw $a0,0($s2)#recebendo em $a0 o valor da posição do array 0,4,8

	#se o valor da posição 4i for maior que zero, pula a posição
	addi $s0,$s0,1#somando o valor do iterador
	bgtz $a0,begin_loop_vetor_num_do_cliente
	
	#se o valor da posição não for maior que zero
	li $a0,0 #seta aquela posição com valor igual a 1500
	sw $a0,0($t0)
	
	j begin_loop_vetor_num_do_cliente

# --------------------------------------------------------------------------------
# Funções de setar o as posições não ocupadas do vetor de conta de origem das trasnsações de débito
# --------------------------------------------------------------------------------
setar_valores_vetor_conta_de_origem_debito:
	li $s0,0#ser o iterador do loop
	la $t0,vetor_conta_origem_debito #reg para guardar o vetor de saldo dos clientes
	
	begin_loop_vetor_conta_de_origem_debito:
	bgt $s0,50,finalizar_programa#se $s0 for maior que 50
	sll $s2,$s0,2 # $s2 = 4i
	
	addu $s2,$s2,$t0 #4i=4i+ local de memoria do array saldo dos clientes ---> EX: 4+1000
	lw $a0,0($s2)#recebendo em $a0 o valor da posição do array 0,4,8

	#se o valor da posição 4i for maior que zero, pula a posição
	addi $s0,$s0,1#somando o valor do iterador
	bgtz $a0,begin_loop_vetor_conta_de_origem_debito
	
	#se o valor da posição não for maior que zero
	li $a0,0 #seta aquela posição com valor igual a 1500
	sw $a0,0($t0)
	
	j begin_loop_vetor_conta_de_origem_debito
	
# --------------------------------------------------------------------------------
# Funções de setar o as posições não ocupadas do vetor de conta de destino das trasnsações de débito
# --------------------------------------------------------------------------------
setar_valores_vetor_conta_de_destino_debito:
	li $s0,0#ser o iterador do loop
	la $t0,vetor_conta_destino_debito #reg para guardar o vetor de saldo dos clientes
	
	begin_loop_vetor_conta_de_destino_debito:
	bgt $s0,50,finalizar_programa#se $s0 for maior que 50
	sll $s2,$s0,2 # $s2 = 4i
	
	addu $s2,$s2,$t0 #4i=4i+ local de memoria do array saldo dos clientes ---> EX: 4+1000
	lw $a0,0($s2)#recebendo em $a0 o valor da posição do array 0,4,8

	#se o valor da posição 4i for maior que zero, pula a posição
	addi $s0,$s0,1#somando o valor do iterador
	bgtz $a0,begin_loop_vetor_conta_de_destino_debito
	
	#se o valor da posição não for maior que zero
	li $a0,0 #seta aquela posição com valor igual a 1500
	sw $a0,0($t0)
	
	j begin_loop_vetor_conta_de_destino_debito
	
# --------------------------------------------------------------------------------
# Funções de setar o as posições não ocupadas do vetor de valor da transação das trasnsações de débito
# --------------------------------------------------------------------------------
setar_valores_vetor_valor_da_transação_de_debito:
	li $s0,0#ser o iterador do loop
	la $t0,vetor_valor_trasacao_debito #reg para guardar o vetor de saldo dos clientes
	
	begin_loop_vetor_valor_transação_debito:
	bgt $s0,50,finalizar_programa#se $s0 for maior que 50
	sll $s2,$s0,2 # $s2 = 4i
	
	addu $s2,$s2,$t0 #4i=4i+ local de memoria do array saldo dos clientes ---> EX: 4+1000
	lw $a0,0($s2)#recebendo em $a0 o valor da posição do array 0,4,8

	#se o valor da posição 4i for maior que zero, pula a posição
	addi $s0,$s0,1#somando o valor do iterador
	bgtz $a0,begin_loop_vetor_valor_transação_debito
	
	#se o valor da posição não for maior que zero
	li $a0,0 #seta aquela posição com valor igual a 1500
	sw $a0,0($t0)
	
	j begin_loop_vetor_valor_transação_debito
	
# --------------------------------------------------------------------------------
# Funções de setar o as posições não ocupadas do vetor de data da transação das trasnsações de débito
# --------------------------------------------------------------------------------
setar_valores_vetor_data_da_transação_debito:
	li $s0,0#ser o iterador do loop
	la $t0,vetor_data_transacao_debito #reg para guardar o vetor de saldo dos clientes
	
	begin_loop_vetor_data_transação_debito:
	bgt $s0,50,finalizar_programa#se $s0 for maior que 50
	sll $s2,$s0,2 # $s2 = 4i
	
	addu $s2,$s2,$t0 #4i=4i+ local de memoria do array saldo dos clientes ---> EX: 4+1000
	lw $a0,0($s2)#recebendo em $a0 o valor da posição do array 0,4,8

	#se o valor da posição 4i for maior que zero, pula a posição
	addi $s0,$s0,1#somando o valor do iterador
	bgtz $a0,begin_loop_vetor_data_transação_debito
	
	#se o valor da posição não for maior que zero
	li $a0,0 #seta aquela posição com valor igual a 1500
	sw $a0,0($t0)
	
	j begin_loop_vetor_data_transação_debito

# --------------------------------------------------------------------------------
# Funções de setar o as posições não ocupadas do vetor de conta de origem das trasnsações de débito
# --------------------------------------------------------------------------------
setar_valores_vetor_conta_de_origem_credito:
	li $s0,0#ser o iterador do loop
	la $t0,vetor_conta_origem_credito #reg para guardar o vetor de saldo dos clientes
	
	begin_loop_vetor_conta_de_origem_credito:
	bgt $s0,50,finalizar_programa#se $s0 for maior que 50
	sll $s2,$s0,2 # $s2 = 4i
	
	addu $s2,$s2,$t0 #4i=4i+ local de memoria do array saldo dos clientes ---> EX: 4+1000
	lw $a0,0($s2)#recebendo em $a0 o valor da posição do array 0,4,8

	#se o valor da posição 4i for maior que zero, pula a posição
	addi $s0,$s0,1#somando o valor do iterador
	bgtz $a0,begin_loop_vetor_conta_de_origem_credito
	
	#se o valor da posição não for maior que zero
	li $a0,0 #seta aquela posição com valor igual a 1500
	sw $a0,0($t0)
	
	j begin_loop_vetor_conta_de_origem_credito
	
# --------------------------------------------------------------------------------
# Funções de setar o as posições não ocupadas do vetor de conta de destino das trasnsações de débito
# --------------------------------------------------------------------------------
setar_valores_vetor_conta_de_destino_credito:
	li $s0,0#ser o iterador do loop
	la $t0,vetor_conta_destino_credito #reg para guardar o vetor de saldo dos clientes
	
	begin_loop_vetor_conta_de_destino_credito:
	bgt $s0,50,finalizar_programa#se $s0 for maior que 50
	sll $s2,$s0,2 # $s2 = 4i
	
	addu $s2,$s2,$t0 #4i=4i+ local de memoria do array saldo dos clientes ---> EX: 4+1000
	lw $a0,0($s2)#recebendo em $a0 o valor da posição do array 0,4,8

	#se o valor da posição 4i for maior que zero, pula a posição
	addi $s0,$s0,1#somando o valor do iterador
	bgtz $a0,begin_loop_vetor_conta_de_destino_credito
	
	#se o valor da posição não for maior que zero
	li $a0,0 #seta aquela posição com valor igual a 1500
	sw $a0,0($t0)
	
	j begin_loop_vetor_conta_de_destino_credito
	
# --------------------------------------------------------------------------------
# Funções de setar o as posições não ocupadas do vetor de valor da transação das trasnsações de débito
# --------------------------------------------------------------------------------
setar_valores_vetor_valor_da_transação_de_credito:
	li $s0,0#ser o iterador do loop
	la $t0,vetor_valor_trasacao_credito #reg para guardar o vetor de saldo dos clientes
	
	begin_loop_vetor_valor_transação_credito:
	bgt $s0,50,finalizar_programa#se $s0 for maior que 50
	sll $s2,$s0,2 # $s2 = 4i
	
	addu $s2,$s2,$t0 #4i=4i+ local de memoria do array saldo dos clientes ---> EX: 4+1000
	lw $a0,0($s2)#recebendo em $a0 o valor da posição do array 0,4,8

	#se o valor da posição 4i for maior que zero, pula a posição
	addi $s0,$s0,1#somando o valor do iterador
	bgtz $a0,begin_loop_vetor_valor_transação_credito
	
	#se o valor da posição não for maior que zero
	li $a0,0 #seta aquela posição com valor igual a 1500
	sw $a0,0($t0)
	
	j begin_loop_vetor_valor_transação_credito
	
# --------------------------------------------------------------------------------
# Funções de setar o as posições não ocupadas do vetor de data da transação das trasnsações de débito
# --------------------------------------------------------------------------------
setar_valores_vetor_data_da_transação_credito:
	li $s0,0#ser o iterador do loop
	la $t0,vetor_data_transacao_credito #reg para guardar o vetor de saldo dos clientes
	
	begin_loop_vetor_data_transação_credito:
	bgt $s0,50,finalizar_programa#se $s0 for maior que 50
	sll $s2,$s0,2 # $s2 = 4i
	
	addu $s2,$s2,$t0 #4i=4i+ local de memoria do array saldo dos clientes ---> EX: 4+1000
	lw $a0,0($s2)#recebendo em $a0 o valor da posição do array 0,4,8

	#se o valor da posição 4i for maior que zero, pula a posição
	addi $s0,$s0,1#somando o valor do iterador
	bgtz $a0,begin_loop_vetor_data_transação_credito
	
	#se o valor da posição não for maior que zero
	li $a0,0 #seta aquela posição com valor igual a 1500
	sw $a0,0($t0)
	
	j begin_loop_vetor_data_transação_credito

# --------------------------------------------------------------------------------
# Opção sair/opção inválida do menu
# --------------------------------------------------------------------------------
sair:
    # Logica para encerrar o programa
    # (substitua por sua implementacao)
    li $v0, 10
    syscall

opcao_invalida:
    # Mensagem para opsao invalida
    li $v0, 4
    la $a0, INVALID_MSG
    syscall

    j menu
    
    cpf_ja_existente:
    # Mensagem para opcao invalida
    li $v0, 4
    la $a0,msg_cpf_ja_existente
    syscall

    jal continua

# --------------------------------------------------------------------------------
# Funções de manipulação de string "String.h"
# --------------------------------------------------------------------------------
strcmp:
	# -----------------------------------------------------------------------------------
	# Funcao que compara duas strings
		
	#Parametros:
		# Str1 -> $a0(CPF que foi digitado)
		# Str2 -> vetor_conta_origem_debito[$t2](CPF de origem da transacao atual do loop)
	#Retorno da funcao no deve ser colocado no $t3
		# 0 caso as strings sejam iguais
		# negativo se a primeira for menor que a segunda
		# positivo se a primeira for maior que a segunda
	# -----------------------------------------------------------------------------------

# --------------------------------------------------------------------------------
# Funções auxiliares
# --------------------------------------------------------------------------------
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
