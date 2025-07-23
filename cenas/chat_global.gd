extends Node2D

@onready var slot_mensagem_scene := preload("res://cenas/mensagem_slot.tscn")
@onready var container_mensagens := $fundo_chat/ScrollContainer/VBoxContainer

var online := true  # ✅ Altere para true para ativar modo online

func _ready():
	if online:
		Socket.connect("server_receive", get_message)
	else:
		# Mensagem de teste recebida (esquerda)
		adicionar_mensagem("helcio", "Mensagem offline de teste (recebida)", false)
		# Mensagem de teste enviada (direita)
		adicionar_mensagem("Você", "Mensagem offline de teste (enviada)", true)

func get_message(flag, response):
	if flag != "get_message":
		return

	var nome = response.get("username", "Desconhecido")
	var texto = response.get("message", "")
	adicionar_mensagem(nome, texto, false)
	print("💬 Mensagem recebida:", response)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_ENTER, KEY_KP_ENTER:
				_enviar_mensagem()
			KEY_E:
				print("🟢 Tecla E pressionada")

func _on_enviar_botao_pressed() -> void:
	_enviar_mensagem()

func _enviar_mensagem():
	var chat_enviar = $fundo_chat/enviar_botao/chat_global.text.strip_edges()
	if chat_enviar == "":
		return

	if online:
		Socket.enviar_json("enviar_mensagem_chat", {
			"id": Sessao.id,
			"chat_enviar": chat_enviar
		})
	else:
		var nome = Sessao.nick if Sessao.has_meta("nick") else "Você"
		adicionar_mensagem(nome, chat_enviar, true)

	$fundo_chat/enviar_botao/chat_global.text = ""

func adicionar_mensagem(nick: String, texto: String, enviada_por_mim: bool = false):
	var novo_slot = slot_mensagem_scene.instantiate()
	novo_slot.get_node("VBoxContainer/HBoxContainer/nick").text = nick
	novo_slot.get_node("VBoxContainer/texto").text = texto
	
	var hbox = novo_slot.get_node("VBoxContainer/HBoxContainer")
	
	# Remove todos os filhos existentes para evitar acumulados de spacer
	for child in hbox.get_children():
		if child.name == "Spacer":
			child.queue_free()
	
	if enviada_por_mim:
		# Mensagem enviada: adiciona spacer na esquerda para empurrar à direita
		var spacer = Control.new()
		spacer.name = "Spacer"
		spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(spacer, true)  # adiciona spacer como primeiro filho
	else:
		# Mensagem recebida: adiciona spacer na direita para empurrar à esquerda
		var spacer = Control.new()
		spacer.name = "Spacer"
		spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(spacer, false) # adiciona spacer como último filho
	
	container_mensagens.add_child(novo_slot)
