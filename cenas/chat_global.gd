extends Node2D

@onready var slot_mensagem_scene := preload("res://cenas/mensagem_slot.tscn")
@onready var container_mensagens := $chat/fundo_chat/ScrollContainer/VBoxContainer

var online := true  # ✅ Altere para true para ativar modo online
var mouse_layer = false
var maximizado = true
var minimizar = true
var arrastar = false
var minimizar_user_online = false
#mouse_sobre_chat = false
func _ready():
	$chat/fundo_chat/chat_global2/mandar_mensagem.text = ""
	#$AnimationPlayer.play("minimizar_player_online_2")
	
	if online:
		Socket.connect("server_receive", get_message)
	else:
		adicionar_mensagem("helcio", "Mensagem offline de teste (recebida)", false)
		adicionar_mensagem("Você", "Mensagem offline de teste (enviada)", true)

	# Conecta o ENTER ao envio direto, sem depender de _input
	$chat/fundo_chat/chat_global2/mandar_mensagem.connect("text_submitted", Callable(self, "_enviar_mensagem"))

func get_message(flag, response):
	if flag != "get_message":
		return

	var nome = response.get("username", "Desconhecido")
	var texto = response.get("message", "")
	adicionar_mensagem(nome, texto, false)
	print("💬 Mensagem recebida:", response)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if arrastar == true and not minimizar_user_online == false:
			$".".global_position = get_global_mouse_position()
		else:
			pass
		match event.keycode:
			KEY_ENTER, KEY_KP_ENTER:
				_enviar_mensagem()
				print("apertou")
			KEY_E:
				print("🟢 Tecla E pressionada")



func _enviar_mensagem():
	var chat_enviar = $chat/fundo_chat/chat_global2/mandar_mensagem.text.strip_edges()
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

	$chat/fundo_chat/chat_global2/mandar_mensagem.text = ""

	
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
	
	




func _on_minimizar_pressed() -> void:
	minimizar = true
	$AnimationPlayer.play("minimizar_global")


func _on_maximizar_pressed() -> void:
	minimizar = false
	$AnimationPlayer.play_backwards("minimizar_global")
	pass # Replace with function body.


func _on_panel_container_mouse_entered() -> void:
	if maximizado and not minimizar_user_online == false:
		Global.mouse_sobre_chat = true
	else:
		if not minimizar_user_online == false:
			Global.mouse_sobre_chat = false


func _on_panel_container_mouse_exited() -> void:
	if maximizado and not minimizar_user_online == false:
		Global.mouse_sobre_chat = false
		print("falso_chat")
	else:
		if not minimizar_user_online == false:
			Global.mouse_sobre_chat = false


func _on_painel_arrasto_mouse_entered() -> void:
	arrastar = true
	print("dentrooooooo")



func _on_painel_arrasto_mouse_exited() -> void:
	arrastar = false



func _on_minimizar_user_online_pressed() -> void:
	$AnimationPlayer.play("minimizar_player_online")
	minimizar_user_online = true


func _on_maximizar_user_online_pressed() -> void:
	$AnimationPlayer.play_backwards("minimizar_player_online")
	minimizar_user_online = false
