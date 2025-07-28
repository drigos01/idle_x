extends Node2D

var online := true # Modo offline para testes

@onready var slot_mensagem_scene = preload("res://cenas/mensagem_slot.tscn")
#var cena_login_packed = preload("res://cenas/login.tscn")

@onready var container_mensagens = $chat/fundo_chat/ScrollContainer/VBoxContainer
@onready var senha_input = $senha
@onready var btn_enviar = $enviar

var aguardando_resposta := false
var timer_timeout: Timer

func _ready() -> void:
	Socket.connect("server_receive", _on_server_response)
	var anim_player = $show_erro/show_erro.get_node("AnimationPlayer")
	anim_player.animation_finished.connect(_on_animation_finished)
	# Configura o campo de senha para esconder o texto automaticamente
	if senha_input is LineEdit:
		senha_input.secret = true
	else:
		push_warning("O nó senha_input não é um LineEdit - a propriedade secret não está disponível")

	timer_timeout = Timer.new()
	timer_timeout.wait_time = 10.0
	timer_timeout.one_shot = true
	timer_timeout.timeout.connect(_on_timeout)
	add_child(timer_timeout)

	$enviar.disabled = false


func _on_server_response(flag, response):
	if flag == "registered":
		aguardando_resposta = false
		timer_timeout.stop()

		if !response.has("status") or response.status != 201:
			show_erro(response.message, Color8(255, 0, 0))
		else:
			show_erro(response.message, Color8(0, 200, 0))
			_limpar_campos()

func _on_timeout() -> void:
	aguardando_resposta = false
	show_erro("Tempo de resposta do servidor excedido. Tente novamente.", Color8(255, 0, 0))
	_habilitar_envio(true)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		if aguardando_resposta:
			show_erro("Aguarde a resposta do servidor...", Color8(255, 150, 0))
			return

		var username = $nick.text.strip_edges()
		var email = $email.text.strip_edges()
		var senha = senha_input.text.strip_edges()

		# Validações
		var erro = validar_username(username)
		if erro != "":
			show_erro(erro, Color8(255, 0, 0))
			return

		erro = validar_email(email)
		if erro != "":
			show_erro(erro, Color8(255, 0, 0))
			return

		erro = validar_senha(senha)
		if erro != "":
			show_erro(erro, Color8(255, 0, 0))
			return

		if online:
			aguardando_resposta = true
			_habilitar_envio(false)
			Socket.enviar_json("registering", {
				"id": Sessao.id,
				"username": username,
				"email": email,
				"password": senha
			})
			timer_timeout.start()
		else:
			show_erro("Registro simulado (offline).", Color8(0, 200, 0))
			_limpar_campos()
func _on_enviar_pressed() -> void:
	if aguardando_resposta:
		show_erro("Aguarde a resposta do servidor...", Color8(255, 150, 0))
		return

	var username = $nick.text.strip_edges()
	var email = $email.text.strip_edges()
	var senha = senha_input.text.strip_edges()

	# Validações
	var erro = validar_username(username)
	if erro != "":
		show_erro(erro, Color8(255, 0, 0))
		return

	erro = validar_email(email)
	if erro != "":
		show_erro(erro, Color8(255, 0, 0))
		return

	erro = validar_senha(senha)
	if erro != "":
		show_erro(erro, Color8(255, 0, 0))
		return

	if online:
		aguardando_resposta = true
		_habilitar_envio(false)
		Socket.enviar_json("registering", {
			"id": Sessao.id,
			"username": username,
			"email": email,
			"password": senha
		})
		timer_timeout.start()
	else:
		show_erro("Registro simulado (offline).", Color8(0, 200, 0))
		_limpar_campos()

func validar_username(username: String) -> String:
	if username.is_empty():
		return "O nome de nick não pode estar vazio."
	if username.length() < 3 or username.length() > 13:
		return "O nome de nick deve ter entre 3 e 13 caracteres."
	return ""

func validar_email(email: String) -> String:
	if email.is_empty():
		return "O email não pode estar vazio."
	if !email_valido(email):
		return "Email inválido. Use o formato: usuario@dominio.com"
	return ""

func validar_senha(senha: String) -> String:
	if senha.is_empty():
		return "A senha não pode estar vazia."
	if senha.length() < 9 or senha.length() > 31:
		return "A senha deve ter entre 9 e 31 caracteres."
	return ""

func email_valido(email: String) -> bool:
	var regex = RegEx.new()
	# Padrão simples de validação de email
	regex.compile("^[\\w\\-\\.]+@([\\w-]+\\.)+[\\w-]{2,}$")
	return regex.search(email) != null

func show_erro(texto: String, cor_fundo: Color = Color8(255, 0, 0)) -> void:
	var label = $show_erro/show_erro/label_mensagem
	label.text = texto
	label.self_modulate = Color.WHITE
#
	var painel = $show_erro/show_erro/ColorRect
	painel.add_theme_color_override("panel", cor_fundo)
#
	$show_erro.visible = true
	$show_erro.modulate.a = 1.0
	$show_erro.position.y = 20

	$show_erro/show_erro/AnimationPlayer.play("aparecer")
#
	if $show_erro/show_erro/TimerErro.is_stopped():
		$show_erro/show_erro/TimerErro.stop()
	$show_erro/show_erro/TimerErro.wait_time = 3.0
	$show_erro/show_erro/TimerErro.start()

func _on_timer_erro_timeout() -> void:
	$show_erro/show_erro/AnimationPlayer.play("desaparecer")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "desaparecer":
		$show_erro.visible = false
		
#func _on_timer_erro_timeout() -> void:
	#$show_erro/AnimationPlayer.play("desaparecer")
	#await $show_erro/AnimationPlayer.animation_finished
	#$show_erro.visible = false

func _limpar_campos() -> void:
	$nick.text = ""
	$email.text = ""
	senha_input.text = ""
	$nick.grab_focus()
	get_tree().change_scene_to_file("res://cenas/login.tscn")
func _habilitar_envio(habilitar: bool) -> void:
	btn_enviar.disabled = !habilitar
	btn_enviar.text = "Enviando..." if !habilitar else "Enviar"


func _on_login_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/login.tscn")
