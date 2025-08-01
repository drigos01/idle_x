extends Node2D

@onready var slot_mensagem_scene = preload("res://cenas/painel_selecao_personagem.tscn")
@onready var slot_severs = preload("res://cenas/panel_serve.tscn")

@onready var painel_container = $"SeleçãoPersonagem/ScrollContainer/HBoxContainer"
@onready var container_mensagens = $SlotSeerve/ScrollContainer/VBoxContainer # Altere esse caminho para o container real onde você quer instanciar os servidores

var slot_selecionado = Global.selecionado_slots_selecao
var online = true

func _ready():
	if !online:
		buscar_servidores()
	$Placas7/numero_slots.text = str(Global.slots_disponiveis)
	mostrar_slots_excedentes()


func mostrar_slots_excedentes():
	for child in painel_container.get_children():
		child.queue_free()

	for i in range(Global.slots_disponiveis):
		var slot = slot_mensagem_scene.instantiate()

		var selecionar_rect = slot.get_node_or_null("slots_selecao/selecionar")
		if selecionar_rect:
			selecionar_rect.visible = false

		var area_mouse = slot.get_node_or_null("slots_selecao")

		if area_mouse:
			if (
				not area_mouse.is_connected("mouse_entered", Callable(self, "_on_slot_mouse_entered").bind(selecionar_rect)) and
				not area_mouse.is_connected("mouse_exited", Callable(self, "_on_slot_mouse_exited").bind(selecionar_rect))
			):
				area_mouse.connect("mouse_entered", Callable(self, "_on_slot_mouse_entered").bind(selecionar_rect))
				area_mouse.connect("mouse_exited", Callable(self, "_on_slot_mouse_exited").bind(selecionar_rect))

		if i < Global.personagens_criados.size():
			var dados = Global.personagens_criados[i]
			var label_nome = slot.get_node_or_null("slots_selecao/organizador/nome")
			if label_nome:
				label_nome.text = str(dados.get("nome", "Sem Nome"))

			var imagem_personagem = slot.get_node_or_null("slots_selecao/organizador/imagem_fundo")
			if imagem_personagem and imagem_personagem is Sprite2D:
				imagem_personagem.texture = dados.get("imagem")
				imagem_personagem.region_enabled = true
				imagem_personagem.region_rect = dados.get("imagem_position", Rect2())

			var token_personagem = slot.get_node_or_null("slots_selecao/organizador/token")
			if token_personagem and token_personagem is Sprite2D:
				token_personagem.texture = dados.get("token")
				token_personagem.region_enabled = true
				token_personagem.region_rect = dados.get("token_position", Rect2())
		else:
			var label_nome = slot.get_node_or_null("slots_selecao/organizador/nome")
			if label_nome:
				label_nome.text = "Vazio"

		painel_container.add_child(slot)


func _on_login_pressed():
	if Global.selecionado_slots_estado == "Vazio":
		get_tree().change_scene_to_file("res://cenas/criacao_de_personagem.tscn")
	elif Global.selecionado_slots_estado != "Vazio":
		get_tree().change_scene_to_file("res://cenas/cidade_1.tscn")


func _on_login_mouse_entered() -> void:
	Global.botao_selecao = true


func _on_login_mouse_exited() -> void:
	Global.botao_selecao = false


func buscar_servidores():
	if !online:
		show_erro("Busca simulada (offline). Nenhum servidor real será listado.", Color8(150, 150, 0))
		var servidores_fake = [
			{"nome": "Servidor A", "ip": "192.168.0.2"},
			{"nome": "Servidor B", "ip": "192.168.0.3"}
		]
		instanciar_slots_servidor(servidores_fake)
		return

	Socket.connect("resposta_busca_servidores", _on_resposta_busca_servidores)
	Socket.enviar_json("buscar_servidores", {})
	show_erro("Buscando servidores...", Color8(0, 100, 200))


func _on_resposta_busca_servidores(data):
	if !online:
		return

	print("DEBUG: Dados recebidos no sinal:", data)

	if typeof(data) != TYPE_DICTIONARY:
		show_erro("Resposta inválida do servidor.", Color8(255, 50, 0))
		return

	if !data.has("servidores") or typeof(data.servidores) != TYPE_ARRAY or data.servidores.size() == 0:
		show_erro("Nenhum servidor encontrado.", Color8(255, 100, 0))
		return

	instanciar_slots_servidor(data.servidores)


func instanciar_slots_servidor(lista_servidores: Array):
	for child in container_mensagens.get_children():
		child.queue_free()

	for servidor in lista_servidores:
		var slot = slot_severs.instantiate()
		container_mensagens.add_child(slot)

		var label_nome = slot.get_node_or_null("ColorRect2/LabelNome")
		if label_nome:
			label_nome.text = servidor.nome

		var label_ip = slot.get_node_or_null("ColorRect2/LabelIP")
		if label_ip:
			label_ip.text = servidor.ip

		var botao_conectar = slot.get_node_or_null("ColorRect2/BotaoConectar")
		if botao_conectar:
			botao_conectar.pressed.connect(func():
				conectar_servidor(servidor.ip)
			)


func conectar_servidor(ip: String):
	show_erro("Conectando ao servidor " + ip, Color8(0, 150, 255))

	if !online:
		await get_tree().create_timer(1.0).timeout # Simula um tempo de espera
		show_erro("Conexão simulada (offline) com " + ip + " estabelecida.", Color8(0, 255, 0))
		return

	# Conexão real
	Socket.conectar_ao_servidor(ip)


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


func _on_timer_erro_timeout() -> void:
	$show_erro/show_erro/AnimationPlayer.play("desaparecer")


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "desaparecer":
		$show_erro.visible = false


func _on_criar_personagem_pressed():
	get_tree().change_scene_to_file("res://cenas/criacao_de_personagem.tscn")
