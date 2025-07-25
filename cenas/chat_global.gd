extends Node2D

@onready var slot_mensagem_scene := preload("res://cenas/mensagem_slot.tscn")
@onready var container_mensagens := $chat/fundo_chat/ScrollContainer/VBoxContainer

var online := true
var arrastando := false
var offset := Vector2.ZERO
var pode_arrastar = false
var chat_maximizado := true  # Começa como visível
var chat_maximizado_mini = true
var animacao_pendente := ""  # Nome da animação a tocar depois que a atual terminar

func _ready():
	$chat/fundo_chat/chat_global2/mandar_mensagem.text = ""
	
	if online:
		Socket.connect("server_receive", get_message)
	else:
		adicionar_mensagem("helcio", "Mensagem offline de teste (recebida)", false)
		adicionar_mensagem("Você", "Mensagem offline de teste (enviada)", true)

	$chat/fundo_chat/chat_global2/mandar_mensagem.connect("text_submitted", Callable(self, "_enviar_mensagem"))

	$painel_arrasto.connect("gui_input", Callable(self, "_on_painel_arrasto_gui_input"))
	
	# Conecta o sinal para quando a animação terminar
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)

func _process(delta: float) -> void:
	pass  # Removi o print para não poluir o console

func get_message(flag, response):
	if flag != "get_message":
		return

	var nome = response.get("username", "Desconhecido")
	var texto = response.get("message", "")
	adicionar_mensagem(nome, texto, false)
	print("💬 Mensagem recebida:", response)

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
	novo_slot.configurar_espaco(enviada_por_mim)
	container_mensagens.add_child(novo_slot)

func _on_enviar_botao_pressed():
	_enviar_mensagem()

func _on_mandar_mensagem_pressed():
	_enviar_mensagem()

# Lógica de movimentação com clique e arrasto
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and pode_arrastar:
				arrastando = true
				offset = global_position - get_global_mouse_position()
			else:
				arrastando = false
	elif event is InputEventMouseMotion and arrastando:
		global_position = get_global_mouse_position() + offset

func _on_painel_arrasto_mouse_exited() -> void:
	Global.mouse_sobre_chat = false
	pode_arrastar = false

func _on_painel_arrasto_mouse_entered() -> void:
	Global.mouse_sobre_chat = true
	pode_arrastar = true

# Botão minimizar principal - controlando animações sequenciais
func _on_minimizar_pressed() -> void:
	if chat_maximizado and chat_maximizado_mini:
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("maximizar_chat_global")
			Global.mouse_sobre_chat = true
			$painel_arrasto.visible = true
			$painel_arrasto2.visible = true
			$painel_arrasto6.visible = true
			$painel_arrasto7.visible = true
			chat_maximizado = false
		else:
			animacao_pendente = "maximizar_chat_global"

	elif chat_maximizado and not chat_maximizado_mini:
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("minimizar_com_mini_minimizado")
		else:
			animacao_pendente = "minimizar_com_mini_minimizado"

# Quando a animação atual terminar, toca a pendente (se houver)
func _on_animation_finished(anim_name: String) -> void:
	if animacao_pendente != "":
		$AnimationPlayer.play(animacao_pendente)
		animacao_pendente = ""

func _on_maximizar_2_pressed() -> void:
	if not chat_maximizado and not chat_maximizado_mini:
		$AnimationPlayer.play_backwards("maximizar_chat_global")
		Global.mouse_sobre_chat = true
		$painel_arrasto.visible = false
		$painel_arrasto2.visible = false
		$painel_arrasto6.visible = false
		$painel_arrasto7.visible = false
		chat_maximizado = true

func _on_maximizar_user_online_pressed() -> void:
	if not chat_maximizado_mini:
		if $AnimationPlayer.current_animation != "minimizar_player_online_2" or not $AnimationPlayer.is_playing():
			$AnimationPlayer.play_backwards("minimizar_player_online")
			Global.mouse_sobre_chat = true
			$painel_arrasto3.visible = true
			$painel_arrasto4.visible = true
			$painel_arrasto5.visible = true
			chat_maximizado_mini = true

func _on_minimizar_user_online_pressed() -> void:
	if chat_maximizado_mini:
		$AnimationPlayer.play("minimizar_player_online")
		Global.mouse_sobre_chat = true
		$painel_arrasto3.visible = false
		$painel_arrasto4.visible = false
		$painel_arrasto5.visible = false
		chat_maximizado_mini = false
