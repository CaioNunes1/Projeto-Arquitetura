.data
MENU_PROMPT:   .asciiz "Escolha uma opÃ§Ã£o:\n1. Criar conta\n2. Saldo\n3. Depósito\n4. Saque\n5. Imprimir vetor\n6. Efetuar trânsação \n8. Sair\nOpÃ§Ã£o: "
SALDO_MSG:     .asciiz "Seu saldo Ã©: $"
DEPOSITO_MSG:  .asciiz "Digite o valor do depÃ³sito: $"
SAQUE_MSG:     .asciiz "Digite o valor do saque: $"
INVALID_MSG:   .asciiz "OpÃ§Ã£o invÃ¡lida. Tente novamente.\n"
QUEBRA_LINHA:  .asciiz "\n"

msg_Pedir_Nome: .asciiz "Digite seu nome:\n"
nomes: .space 2000
cpf: .space 2000
msg_Pedir_CPF: .asciiz "Digite o seu CPF (Somente nÃºmeros):\n"
msg_pedir_cpf_para_a_conta_destino:.asciiz "Digite o cpf de destino:"

msg_pergunta_tipo_de_transacao:.asciiz"Qual tipo de transação deseja fazer.\n1-Por Débito.\n2-Por crédito"
msg_valor_trans_debito:.asciiz "Digite o valor a ser enviado:"
msg_trans_com_sucesso:.asciiz "Transferência feita com sucesso."

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
cpf_existe:.asciiz "CPF existente"
msg_cpf_nao_existe:.asciiz "CPF não existe ou não encontrado"


iterator:.word 0
indice_nomes:.word 0

prompt:     .asciiz     "Digite uma string:"
dot:        .asciiz     "."
eqmsg:      .asciiz     "strings sao iguais\n"
nemsg:      .asciiz     "strings nao sao iguais\n"
msg_fora_range:.asciiz "fora de range\n"
msg_pula_string:.asciiz "pulou de string\n"
msg_pulou_carac:.asciiz "pulou o caracter\n"
	iterator2:.word 0

str1:       .space      40
str2:       .space      40
.data
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
    beq $t0, 6, efetuar_transacao
    beq $t0, 7, imprimir_transacoes_debito
    beq $t0, 8, imprimir_transacoes_credito
    beq $t0, 9, sair
    j opcao_invalida

# --------------------------------------------------------------------------------
# Opção 1 do menu
# --------------------------------------------------------------------------------
criar_conta:
	lw $s3,num_de_clientes #carregando o nÃºmero de clientes disponÃ­veis
	sll $t7,$s3,2#fazendo $t7= 4*i para guardar corretamente os valores na posiÃ§Ã£o do vetor
	#addi $t3,$t3,1
	#sw $t3,num_de_clientes
	beq $s3,50,menu #se o numero de clientes for igual a zero termina o programa
	
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
	la $a0, nomes
	lw $t0, indice_nomes  # Carrega o índice atual
	sll $t8, $t0, 2      # Calcula o deslocamento (4 * índice)
	addu $a0, $a0, $t8   # Adiciona o deslocamento à base do vetor
	li $a1, 40
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
	#fazer a soma dos valores de $a0 com o $t0 também que foi usado em nome

   	la $a1, 40
   	syscall
	#move $a0,$v0   	
   	##verificar se o cpf jÃ¡ existe, quando for chamar 
   	#$s7 tem a quantidade de elementos armazenada
   	#s3 tem o número de clientes
   	la $a2,vetor_cpf_cliente
   	#subi $t3,$t3,1 #verificando se é o primeiro cpf a ser cadastrado
   	beqz $s3, primeiro_cadastro
   	jal main_funcao
   	
   	#jal verifica_cpf
   	primeiro_cadastro:
   	#addi $t3,$t3,1
   	
   	
   	
   	
   	# a funÃ§Ã£o verifica_cpf
   	#move $s3,$zero
   	lw $s3,num_de_clientes
   	la $a0,cpf
#   	subi $t3,$t3,1
   	sll $t7,$s3,2#$t7=4*indice
   	
   	lw $t0,indice_nomes
   	#colocando denovo o valor de $t7 para ser um multiplo de 4=4i, pois ele mudou de valor quando ele foi para
   	sll $t9,$t0,2 #$t9 = 4*indice
   	addu $a0,$a0,$t9
   	
   	lw $t0, indice_nomes  # Carrega o índice atual
	addiu $t0, $t0, 40     # Incrementa o índice
	sw $t0, indice_nomes  # Armazena o novo índice
   	
   	#registrador para vetor_cpf_cliente
   	la $t6,vetor_cpf_cliente
   	add $t6,$t6,$t7#ajeitando e a cada iteraÃ§Ã£o colocando na posiÃ§Ã£o 4i
   	sw $a0,0($t6)
   	
   	addi $s3,$s3,1
   	sw $s3,num_de_clientes
   	
   	li $v0,1
   	move $a0,$s3
   	syscall
   	
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
	move $s3,$zero
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
    	jal pula_linha
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
# Opção 6 do menu EFETUAR TRANSAÇÕES
# --------------------------------------------------------------------------------
efetuar_transacao:

	li $v0,4
	la $a0,msg_pergunta_tipo_de_transacao
	syscall
	
	li $v0,5#lendo um número
	syscall
	
	move $t0,$v0
	
	beq $t0,1,pagar_por_debito
	#beq $t0,2,pagar_por_credito
	
	pagar_por_debito:
	
	continua3:#continuação do código pra poder retonar de onde tinha parado, no caso retornando para o começo pq não encontrou o cpf
	li $v0,4
	la $a0,msg_Pedir_CPF#pedindo o cpf do remetente, de quem está irá mandar o valor
	syscall
	
	li $v0,8#recebendo valor
	syscall
	
	move $a0,$v0 #movendo pra $a0 para poder entrar na função
	
	jal verifica_cpf_transacao
	continua_transacao:#se o cpf existir ele volta para o código, se não, aparece uma mensagem de não existente
	#posição está em $s1, pois passei para ela no verifica_cpf_transacao
	
	#quando volta de continua transação o  cpf que existe no vetor está em $s1
	li $v0, 4
	move $a0,$s1#imprimindo o cpf só de teste
	syscall
	#pela função a posição do cpf do cliente que irá enviar o valor está em $s1
	
	li $v0,4
	la $a0,msg_pedir_cpf_para_a_conta_destino #mensagem pedindo cpf destino
	syscall
	
	li $v0,8#recebendo o cpf para conferir novamente se existe
	syscall
	
	move $a0,$v0
	jal verifica_cpf_transacao2
	continua_transacao2:
	#a posição do cpf está armazenado em $s2
	
	
	li $v0,4#mensagem para digitar o valor da transferência
	la $a0,msg_valor_trans_debito
	syscall
	
	li $v0,7 #recebendo o valor em double
	syscall
	
	move $t0,$v0#passaando o valor da transferência pra $t0
	
	la $s3,vetor_saldo_cliente
	
	sll $s4,$s1,2 #$s4 recebe a posição do cpf remetente/ do que envia, vezes 4 para poder acessar a posição no vetor
	
	addu $s4,$s4,$s3 #$s4 recebe a posição correta para poder pegar pegar o saldo do cliente
	
	lw $t1, 0($s4) #acessando a posição do rementente para poder subtrair o valor, $t1 recebe o saldo do cpf específico
	
	sub $t1,$t1,$t0#subtraindo o valor do que foi enviado
	
	sw $t1,0($s4)# guardando o valor subtraído na conta do remetente
	
	sll $s5,$s2,2 #s5 recebe 4* posição do destinatário da transferência
	
	addu $s5,$s5,$s3
	
	lw $t2,0($5)#guardando em $t2 o valor do saldo do destinatário
	
	add $t2,$t2,$t0#somando os valores
	
	sw $t2,0($s5) #guardando o valor da soma da transferencia para a conta do destinatário no vetor
	
	li $v0,4#mensagem de transfência feita com sucesso
	la $a0,msg_trans_com_sucesso
	syscall
	
	
	

# --------------------------------------------------------------------------------
# Opção 7 do menu
# --------------------------------------------------------------------------------
imprimir_transacoes_debito:
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
		beq $t3, $zero, imprimir_transacao_debito # Comparando o retorno da strcmp e imprimindo cada transacao caso os CPF's deem match
		continua_loop_trasacoes_debito:
		addi $t2, $t2, 1 # incrementando a variavel de controle
		j inicio_loop_trasacoes_debito # volta para o inicio do loop para verificar condicao de parada
	fim_loop_trasacoes_debito:
		j menu # volta para o menu
	
imprimir_transacao_debito:
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
# Opção 8 do menu
# --------------------------------------------------------------------------------
imprimir_transacoes_credito:
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
		beq $t3, $zero, imprimir_transacao_credito # Comparando o retorno da strcmp e imprimindo cada transacao caso os CPF's deem match
		continua_loop_trasacoes_credito:
		addi $t2, $t2, 1 # incrementando a variavel de controle
		j inicio_loop_trasacoes_credito # volta para o inicio do loop para verificar condicao de parada
	fim_loop_trasacoes_credito:
		j menu # volta para o menu

imprimir_transacao_credito:
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
	bgt $s0,50,menu#se $s0 for maior que 50
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
	bgt $s0,50,menu#se $s0 for maior que 50
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
	bgt $s0,50,menu#se $s0 for maior que 50
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
	
	begin_loop_vetor_cpf_setar_0:
	bgt $s0,50,menu#se $s0 for maior que 50
	sll $s2,$s0,2 # $s2 = 4i
	
	addu $s2,$s2,$t0 #4i=4i+ local de memoria do array saldo dos clientes ---> EX: 4+1000
	lb $a0,0($s2)# recebendo em $a0 o valor da posição do array (um caractere)

	#se o valor da posição 4i for maior que zero, pula a posição
	addi $s0,$s0,1#somando o valor do iterador
	bgtz $a0,begin_loop_vetor_cpf_setar_0
	
	#se o valor da posição não for maior que zero
	li $a0,0 #seta aquela posição com valor igual a 1500
	sb $a0,0($t0)
	
	j begin_loop_vetor_cpf_setar_0
	
# --------------------------------------------------------------------------------
# Funções de setar o as posições não ocupadas do vetor de numero do cliente
# --------------------------------------------------------------------------------
setar_valores_vetor_de_numero_da_conta_dos_clientes:
	li $s0,0#ser o iterador do loop
	la $t0,vetor_numero_cliente #reg para guardar o vetor de saldo dos clientes
	
	begin_loop_vetor_num_do_cliente:
	bgt $s0,50,menu#se $s0 for maior que 50
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
	bgt $s0,50,menu#se $s0 for maior que 50
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
	bgt $s0,50,menu#se $s0 for maior que 50
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
	bgt $s0,50,menu#se $s0 for maior que 50
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
	bgt $s0,50,menu#se $s0 for maior que 50
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
# Funções de setar o as posições não ocupadas do vetor de conta de origem das trasnsações de crédito
# --------------------------------------------------------------------------------
setar_valores_vetor_conta_de_origem_credito:
	li $s0,0#ser o iterador do loop
	la $t0,vetor_conta_origem_credito #reg para guardar o vetor de saldo dos clientes
	
	begin_loop_vetor_conta_de_origem_credito:
	bgt $s0,50,menu#se $s0 for maior que 50
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
# Funções de setar o as posições não ocupadas do vetor de conta de destino das trasnsações de crédito
# --------------------------------------------------------------------------------
setar_valores_vetor_conta_de_destino_credito:
	li $s0,0#ser o iterador do loop
	la $t0,vetor_conta_destino_credito #reg para guardar o vetor de saldo dos clientes
	
	begin_loop_vetor_conta_de_destino_credito:
	bgt $s0,50,menu#se $s0 for maior que 50
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
# Funções de setar o as posições não ocupadas do vetor de valor da transação das trasnsações de crédito
# --------------------------------------------------------------------------------
setar_valores_vetor_valor_da_transação_de_credito:
	li $s0,0#ser o iterador do loop
	la $t0,vetor_valor_trasacao_credito #reg para guardar o vetor de saldo dos clientes
	
	begin_loop_vetor_valor_transação_credito:
	bgt $s0,50,menu#se $s0 for maior que 50
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
# Funções de setar o as posições não ocupadas do vetor de data da transação das trasnsações de crédito
# --------------------------------------------------------------------------------
setar_valores_vetor_data_da_transação_credito:
	li $s0,0#ser o iterador do loop
	la $t0,vetor_data_transacao_credito #reg para guardar o vetor de saldo dos clientes
	
	begin_loop_vetor_data_transação_credito:
	bgt $s0,50,menu#se $s0 for maior que 50
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

	#jal continua
    

cpf_nao_existente:
	li $v0, 4
   	la $a0,msg_cpf_nao_existe
    	syscall

    	jal continua3

cpf_encontrado:
    li $v0,4
    la $a0,cpf_existe
    syscall
    
    jal continua_transacao
    
cpf_encontrado2:
    li $v0,4
    la $a0,cpf_existe
    syscall
    
    jal continua_transacao2

# --------------------------------------------------------------------------------
# Funções de manipulação de string "String.h"
# --------------------------------------------------------------------------------
strcmp:
main_funcao:
 # pegando a string que foi lida
 #pegar o vetor específico e a quantidade que foi cadastrada no vetor
    la $t6,str1
    move $t2,$t6
    move    $t2,$a0#guaradando o valor(no caso cpf)
    #sw $t2,str1
    #lw $t2,str1
    
    move $t4,$s3# guardando a quantidade de elementos no vetor no caso cpf
#    move $s3,$zero
    move $s3,$a2#guardando o vetor dos elementos(no caso cpf)
    
    la $s2,str1
    #move $t2,$s2
    
#    la $a3,str2
    
    
    #quando ele sai de getstr o nome está guardado em $t2


# loop de comparação de strings (como strcmp)
cmploop:

    lw $t5,iterator2
    bgt $t5,$t4,reseta_vetor
    
    
    sll $t7,$t5,2#$t6=4i
    addu $t7,$t7,$s3
    lw $s0,0($t7)
    move $t3,$s0
    sw $s0,str2 #guardando a palavra em str2
    move $t3,$s0
    
    la $s0,str2
    
    #move $s0,$a3
    continua_funcao:
    
    
    lb      $t2,0($t6)                   # obtenha o próximo caractere de str1
    lb      $t3,0($s0)                   # obtenha o próximo caractere dos nomes do vetor
    
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
    j       exit

fora_de_range:
	li $v0,4
	la $a0,msg_fora_range
	syscall
# getstr -- solicite e leia a string do usuário
#
# argumentos:
#   t2 -- endereço do buffer de string


# saia do programa
exit:
    li      $v0,10
    syscall


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
	#beq $t1,$t2,continua
	sll $t3,$t1,2 #$t3=4i
	
	addu $t3,$t3,$s1
	
	lw $a0,0($t3)
	
	beq $t0,$a0,cpf_ja_existente
	addi $t1,$t1,1
	j loop_verifica
	
verifica_cpf_transacao:
	#pega o cpf e move para $t0
	move $t0,$a0
	
	li $t1,0
	lw $t2,num_de_clientes
	la $s1,vetor_cpf_cliente
	
	loop_verifica_cpf_transacao:
	beq $t1,$t2,cpf_nao_existente
	sll $t3,$t1,2 #$t3=4i
	
	addu $t3,$t3,$s1
	
	lw $a0,0($t3)
	
	move $s1,$t1#passando a posição para $t1, paraa guardar a posição caso o cpf seja encontrado
	beq $t0,$a0,cpf_encontrado
	addi $t1,$t1,1
	j loop_verifica_cpf_transacao

verifica_cpf_transacao2:
	#pega o cpf e move para $t0
	move $s0,$a0
	
	li $t1,0
	lw $t2,num_de_clientes
	la $s1,vetor_cpf_cliente
	
	loop_verifica_cpf_transacao2:
	beq $t1,$t2,cpf_nao_existente
	sll $t3,$t1,2 #$t3=4i
	
	addu $t3,$t3,$s1
	
	lw $a0,0($t3)
	
	beq $s0,$a0,cpf_encontrado2
	move $s2,$t1 #$s2 recebe a posição a posição em que o cpf do destinatário está
	addi $t1,$t1,1
	j loop_verifica_cpf_transacao2
