extends Node2D

var aberto := false
var saiu := false
var esperar_fechar := false

var aberto2 := false
var saiu2 := false
var esperar_fechar2 := false

var anim = "personagem_layer_abrir"

var total_disponivel = Global.valor_total_distribuir_criacao_personagem
var usado = Global.pontos_usados

var online := false  # <---- MODO ONLINE/TESTE OFFLINE
var aguardando_resposta := false
var timer_timeout: Timer

func _ready():
	#
	$layer/nick/preview_token/personagem.texture = null
	$layer/nick/preview_token/personagem/token2.texture = null 
	
	Socket.connect("server_receive", _on_server_response)
	timer_timeout = Timer.new()
	timer_timeout.wait_time = 10.0
	timer_timeout.one_shot = true
	timer_timeout.timeout.connect(_on_timeout)
	add_child(timer_timeout)
func _process(delta: float) -> void:
	$layer/HBoxContainer/Panel2/layer_atributos/valor_atributos.text = "%d/%d" % [usado, Global.pontos_usados]

func _on_menos_pressed() -> void:
	$layer/HBoxContainer/Panel2/layer_atributos/ScrollContainer/pericias_name/Panel/nome_layer4

func _on_mais_pressed() -> void:
	pass

func show_erro(texto: String, cor_fundo: Color = Color8(255, 0, 0)) -> void:
	var label = $show_erro/label_mensagem
	label.text = texto
	label.self_modulate = Color.WHITE

	var painel = $show_erro/ColorRect
	painel.add_theme_color_override("panel", cor_fundo)

	$show_erro.visible = true
	$show_erro.modulate.a = 1.0
	$show_erro.position.y = 20
	$show_erro/AnimationPlayer.play("aparecer")

	if $show_erro/TimerErro.is_stopped():
		$show_erro/TimerErro.stop()

	$show_erro/TimerErro.wait_time = 3.0
	$show_erro/TimerErro.start()

# Atualiza qual layer está visível com base nos abertos
func atualizar_visibilidade_layers() -> void:
	$layer/layer_raca_per.visible = aberto and not aberto2
	$layer/layer_raca_per2.visible = aberto2 and not aberto

# Funções auxiliares
func fechar_personagem_layer():
	$AnimationPlayer.play_backwards(anim)
	Global.descricao_raca = ""
	aberto = false
	saiu = false
	esperar_fechar = false
	atualizar_visibilidade_layers()

func fechar_token_layer():
	$AnimationPlayer2.play_backwards("token_abrir")
	Global.descricao_raca = ""
	aberto2 = false
	saiu2 = false
	esperar_fechar2 = false
	atualizar_visibilidade_layers()

# Entradas e saídas do slot personagem
func _on_area_slot_mouse_entered() -> void:
	if aberto2:
		$AnimationPlayer2.play_backwards("token_abrir")
		aberto2 = false

	if not aberto:
		aberto = true
		$AnimationPlayer.play(anim)
	elif saiu:
		fechar_personagem_layer()

	atualizar_visibilidade_layers()

func _on_area_slot_mouse_exited() -> void:
	if aberto:
		saiu = true
		$layer/personagem/descricao_racas.visible = false

# Slots que fecham personagem diretamente
func _on_area_slot_2_mouse_entered() -> void: fechar_personagem_layer()
func _on_area_slot_3_mouse_entered() -> void: fechar_personagem_layer()
func _on_area_slot_4_mouse_entered() -> void: fechar_personagem_layer()
func _on_area_slot_5_mouse_entered() -> void: fechar_personagem_layer()

# Entradas e saídas do slot token
func _on_area_slot_token_mouse_entered() -> void:
	if aberto:
		$AnimationPlayer.play_backwards(anim)
		aberto = false

	if not aberto2:
		aberto2 = true
		$AnimationPlayer2.play("token_abrir")
	elif saiu2:
		fechar_token_layer()

	atualizar_visibilidade_layers()

func _on_area_slot_token_mouse_exited() -> void:
	if aberto2:
		saiu2 = true

# Slots que fecham token diretamente
func _on_area_slot_token_2_mouse_entered() -> void: fechar_token_layer()
func _on_area_slot_token_3_mouse_entered() -> void: fechar_token_layer()
func _on_area_slot_token_4_mouse_entered() -> void: fechar_token_layer()



func _on_cadastra_pressed() -> void:
	if aguardando_resposta:
		show_erro("Aguarde a resposta do servidor...", Color8(255, 150, 0))
		return

	var nome = $layer/nick.text.strip_edges()
	if nome.length() < 1 or nome.length() > 20:
		show_erro("O nome do seu personagem deve ter entre 1 e 20 caracteres.", Color8(255, 0, 0))
		return

	var skin_texture = $layer/nick/preview_token/personagem.texture
	if not skin_texture:
		show_erro("Uma skin deve ser escolhida", Color8(255, 0, 0))
		return

	var token_texture = $layer/nick/preview_token/personagem/token2.texture
	if not token_texture:
		show_erro("Um token deve ser escolhido", Color8(255, 0, 0))
		return

	var raca = $layer/descricao_result.text.strip_edges()
	if raca == "":
		show_erro("Uma raça deve ser definida.", Color8(255, 0, 0))
		return

	# Enviar para o servidor
	if online:
		aguardando_resposta = true
		timer_timeout.start()

		Socket.enviar_json("cadastrar_personagem", {
			"id": Sessao.id,
			"nome": nome,
			"raca": raca,
			"skin": skin_texture.resource_path,
			"token": token_texture.resource_path
		})
	else:
		show_erro("Cadastro simulado (offline).", Color8(0, 200, 0))

		# Cria novo personagem local
		var personagem_node = $layer/nick/preview_token/personagem
		var token_node = personagem_node.get_node("token2")

		var novo_personagem = {
			"nome": $layer/nick.text,
			"imagem": personagem_node.texture,
			"imagem_position": personagem_node.region_rect,
			"token": token_node.texture,
			"token_position": token_node.region_rect,
			"nivel": 1
		}

		# Evita duplicatas pelo nome
		var nome_existente = Global.personagens_criados.any(func(p): return p["nome"] == novo_personagem["nome"])
		if not nome_existente:
			Global.personagens_criados.append(novo_personagem)

		# Troca de cena mesmo no modo offline
		print(Global.personagens_criados)
		get_tree().change_scene_to_file("res://cenas/seleção_personagem.tscn")
		
		
		# Aqui você pode simular o cadastro local
func _on_server_response(flag, response):
	if flag == "personagem_cadastrado":
		aguardando_resposta = false
		timer_timeout.stop()

		if !response.has("status") or response.status != 201:
			show_erro("Erro ao cadastrar personagem: " + response.message, Color8(255, 0, 0))
		else:
			show_erro("Personagem cadastrado com sucesso!", Color8(0, 200, 0))
			
			# Cria novo personagem
			var personagem_node = $layer/nick/preview_token/personagem
			var token_node = personagem_node.get_node("token2")

			var novo_personagem = {
				"nome": $layer/nick.text,
				"imagem": personagem_node.texture,
				"imagem_position": personagem_node.region_rect,
				"token": token_node.texture,
				"token_position": token_node.region_rect,
				"nivel": 1
			}

			# Evita duplicatas pelo nome
			var nome_existente = Global.personagens_criados.any(func(p): return p["nome"] == novo_personagem["nome"])
			
			if not nome_existente:
				Global.personagens_criados.append(novo_personagem)

			get_tree().change_scene_to_file("res://cenas/seleção_personagem.tscn")


func _on_timeout() -> void:
	aguardando_resposta = false
	show_erro("Tempo de resposta do servidor excedido. Tente novamente.", Color8(255, 0, 0))


func _on_timer_erro_timeout() -> void:
	pass # Replace with function body.
