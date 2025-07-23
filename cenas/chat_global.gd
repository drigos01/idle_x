extends Node2D

@onready var slot_mensagem_scene := preload("res://cenas/mensagem_slot.tscn")
@onready var container_mensagens := $fundo_chat/ScrollContainer/VBoxContainer

var online := false  # ✅ Altere para true para ativar modo online

func _ready():
	$mandar_mensagem/texto_mensagem.text = ""
	
	if online:
		Socket.connect("server_receive", get_message)
	else:
		adicionar_mensagem("helcio", "Mensagem offline de teste (recebida)", false)
		adicionar_mensagem("Você", "Mensagem offline de teste (enviada)", true)

	# Conecta o ENTER ao envio direto, sem depender de _input
	$mandar_mensagem/texto_mensagem.connect("text_submitted", Callable(self, "_enviar_mensagem"))


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
				print("apertou")
			KEY_E:
				print("🟢 Tecla E pressionada")



func _enviar_mensagem():
	var chat_enviar = $mandar_mensagem/texto_mensagem.text.strip_edges()
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

	$mandar_mensagem/texto_mensagem.text = ""

	
func adicionar_mensagem(nick, texto, enviada_por_mim := false):
	var novo_slot = slot_mensagem_scene.instantiate()
	novo_slot.get_node("VBoxContainer/HBoxContainer/nick").text = nick
	novo_slot.get_node("VBoxContainer/texto").text = texto

	novo_slot.configurar_espaco(enviada_por_mim)  # ativa/desativa o espaço interno

	container_mensagens.add_child(novo_slot)


func _on_enviar_botao_pressed() -> void:
	_enviar_mensagem()


func _on_mandar_mensagem_pressed() -> void:
	_enviar_mensagem()
