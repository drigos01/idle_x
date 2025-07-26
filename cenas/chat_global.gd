extends Node2D

@onready var slot_mensagem_scene := preload("res://cenas/mensagem_slot.tscn")
@onready var container_mensagens := $chat/ChatGlobal1/ScrollContainer_usuarios_online/VBoxContainer
@onready var anim_player := $chat/AnimationPlayer
@onready var timer := $Timer
@onready var arrastavel_layer := $layer_arratavel_chat
@onready var arrastavel_online := $layer_arratavel_online

var online := false
var arrastando := false
var offset := Vector2.ZERO
var pode_arrastar := false

var chat_maximizado := true
var online_visivel := true
var cascata_minimizar_online = false
var qual_ta_rodando = ""
# ----------------- READY ------------------

func _ready():
	$chat/ChatGlobal1/chat_global2/mandar_mensagem.text = ""
	
	if online:
		Socket.connect("server_receive", get_message)
	else:
		adicionar_mensagem("helcio", "Mensagem offline de teste (recebida)", false)
		adicionar_mensagem("Você", "Mensagem offline de teste (enviada)", true)

	$chat/ChatGlobal1/chat_global2/mandar_mensagem.connect("text_submitted", Callable(self, "_enviar_mensagem"))
	anim_player.animation_finished.connect(_on_animation_finished)


# ----------------- MENSAGENS ------------------

func get_message(flag, response):
	if flag != "get_message":
		return
	var nome = response.get("username", "Desconhecido")
	var texto = response.get("message", "")
	adicionar_mensagem(nome, texto, false)
	print("💬 Mensagem recebida:", response)


func _enviar_mensagem():
	var chat_enviar = $chat/ChatGlobal1/chat_global2/mandar_mensagem/texto_mensagem.text.strip_edges()
	if chat_enviar == "":
		return
	if online:
		Socket.enviar_json("enviar_mensagem_chat", {
			"id": Sessao.id,
			"chat_enviar": chat_enviar
		})
	else:
		var nome = Sessao.nick if Sessao.has_meta("nick") else "Voce"
		adicionar_mensagem(nome, chat_enviar, true)

	$chat/ChatGlobal1/chat_global2/mandar_mensagem/texto_mensagem.text = ""


func adicionar_mensagem(nick, texto, enviada_por_mim := false):
	var novo_slot = slot_mensagem_scene.instantiate()
	novo_slot.get_node("VBoxContainer/HBoxContainer/nick").text = nick
	novo_slot.get_node("VBoxContainer/texto").text = texto
	novo_slot.configurar_espaco(enviada_por_mim)
	container_mensagens.add_child(novo_slot)


# ----------------- ENVIO ------------------

func _on_enviar_botao_pressed():
	_enviar_mensagem()

func _on_mandar_mensagem_pressed():
	_enviar_mensagem()
	print("ndendjnej")


# ----------------- ARRASTO ------------------

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and pode_arrastar:
			arrastando = true
			offset = global_position - get_global_mouse_position()
		else:
			arrastando = false
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		_enviar_mensagem()
	elif event is InputEventMouseMotion and arrastando:
		global_position = get_global_mouse_position() + offset

func _on_painel_arrasto_mouse_entered():
	Global.mouse_sobre_chat = true
	pode_arrastar = true

func _on_painel_arrasto_mouse_exited():
	Global.mouse_sobre_chat = false
	pode_arrastar = false


# ----------------- ANIMAÇÕES CHAT ------------------

func _on_minimizar_pressed() -> void:
	if anim_player.is_playing() or not chat_maximizado and not cascata_minimizar_online:
		return
	if chat_maximizado and not cascata_minimizar_online:
		anim_player.play("usuarios_online_fechar")
		qual_ta_rodando = "abrir"
		$Timer.start()
		print("🡇 Minimizar Chat")
		return

	if chat_maximizado and cascata_minimizar_online:
		anim_player.play("usuarios_online_fechar_completo")
		qual_ta_rodando = "abrir"
		$Timer.start()
		print("🡇 Minimizar Chat")
		return


func _on_maximizar_2_pressed() -> void:
	if anim_player.is_playing() or chat_maximizado and not cascata_minimizar_online:
		return
	if not chat_maximizado and not cascata_minimizar_online:
		#$chat/online_layer.visible = true
		anim_player.play("fechar")
		qual_ta_rodando = "usuarios_online_fechar_completo_max"
		$Timer.start()
		print("🡇 Minimizar Chat")
		return
	if not chat_maximizado and cascata_minimizar_online:
		anim_player.play("fechar")
		qual_ta_rodando = "usuarios_online_fechar_completo_max_diferente"
		$Timer.start()
		print("🡇 Minimizar Chat")
		return
	


func _on_minimizar_user_online_pressed() -> void:
	if anim_player.is_playing() or not online_visivel:
		return

	anim_player.play("usuarios_online_fechar")
	print("🡇 Minimizar Online")
	cascata_minimizar_online = true


func _on_maximizar_user_online_pressed() -> void:
	if anim_player.is_playing() or online_visivel:
		return

	anim_player.play("usuarios_online_abrir")
	print("🡅 Maximizar Online")
	cascata_minimizar_online = false

# ----------------- FIM DAS ANIMAÇÕES ------------------

func _on_animation_finished(anim_name: String) -> void:
	print("🎬 Finalizou animação:", anim_name)

	match anim_name:
		"abrir":
			chat_maximizado = false
			arrastavel_layer.visible = false
			arrastavel_online.visible = false
			print("🔒 Chat minimizado")

		"fechar":
			chat_maximizado = true
			arrastavel_layer.visible = true
			if online_visivel:
				arrastavel_online.visible = true
			print("🔓 Chat maximizado")

		"usuarios_online_fechar":
			online_visivel = false
			arrastavel_online.visible = false
			print("👥 Online ocultado")

		"usuarios_online_abrir":
			online_visivel = true
			arrastavel_online.visible = true
			print("👥 Online visível")
			
		"usuarios_online_fechar_completo":
			online_visivel = true
			arrastavel_online.visible = true
			print("👥 Online visível")

func _on_timer_timeout() -> void:
	if qual_ta_rodando == "":
		return

	if not anim_player.is_playing():
		if not cascata_minimizar_online and qual_ta_rodando == "abrir":
			anim_player.play("usuarios_online_fechar_completo")
			$time2.start() 
	if not anim_player.is_playing():
		if not anim_player.is_playing() and qual_ta_rodando == "usuarios_online_fechar_completo_max":
			anim_player.play_backwards("usuarios_online_fechar_completo")
			$time2.start()
	if not anim_player.is_playing():
		if not anim_player.is_playing() and qual_ta_rodando == "usuarios_online_fechar_completo_max_diferente":
			anim_player.play_backwards("usuarios_online_fechar_completo")
			$time2.start()
	if not anim_player.is_playing():
		if cascata_minimizar_online:
			anim_player.play("abrir")
			$chat/online_layer.visible = false
			qual_ta_rodando = ""  # Limpa após rodar
	#if not anim_player.is_playing():
		#if cascata_minimizar_online:
			##anim_player.play("fechar")
			#$chat/online_layer.visible = true
			#qual_ta_rodando = ""  # Limpa após rodar
			
			
		


func _on_time_2_timeout() -> void:
	if qual_ta_rodando != "" and qual_ta_rodando == "abrir":
		$chat/online_layer.visible = false
		anim_player.play(qual_ta_rodando)
		print("▶ Rodando via time_2:", qual_ta_rodando)
		qual_ta_rodando = ""  # Limpa após rodar
	if qual_ta_rodando != "" and qual_ta_rodando == "usuarios_online_fechar_completo_max":
		$chat/online_layer.visible = true
		anim_player.play("usuarios_online_abrir")
		print("▶ Rodando via time_2:", qual_ta_rodando)
		qual_ta_rodando = ""  # Limpa após rodar
	if qual_ta_rodando != "" and qual_ta_rodando == "usuarios_online_fechar_completo_max_diferente":
		$chat/online_layer.visible = true
		#anim_player.play("usuarios_online_abrir")
		print("▶ Rodando via time_2:", qual_ta_rodando)
		qual_ta_rodando = ""
	#if qual_ta_rodando != "" and qual_ta_rodando == "usuarios_online_fechar_completo_max":
		#$chat/online_layer.visible = true
		#anim_player.play("usuarios_online_abrir")
		#print("▶ Rodando via time_2:", qual_ta_rodando)
		#qual_ta_rodando = ""  # Limpa após rodar

	$time2.stop()  # Evita loop infinito
