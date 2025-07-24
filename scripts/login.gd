extends Node2D

func _ready():
	Socket.connect("server_receive", _on_session_id_received)
	Socket.connect("server_receive", _on_user_logged_in)

# Recebe ID da sessão
func _on_session_id_received(flag: String, response: Dictionary) -> void:
	if flag != "get_my_id": return
	Sessao.id = response.id

# Recebe dados do usuário logado
func _on_user_logged_in(flag: String, response: Dictionary) -> void:
	if flag != "logged": return
	Global.username = response.username
	get_tree().change_scene_to_file("res://cenas/mundo_1.tscn")

# Quando botão de login é pressionado
func _on_enviar_pressed() -> void:
	var username = $nick.text.strip_edges()
	var senha = $Cadastro4/Cadastro4/senha.text.strip_edges()

	# Validações
	if username.is_empty():
		return show_erro("O nome de usuário não pode estar vazio.")
	if username.length() < 3 or username.length() > 13:
		return show_erro("O nome de usuário deve ter entre 3 e 13 letras.")
	if senha.is_empty():
		return show_erro("A senha não pode estar vazia.")
	if senha.length() < 9 or senha.length() > 31:
		return show_erro("A senha deve ter entre 9 e 31 caracteres.")

	# Envia dados para o servidor
	Socket.enviar_json("logging", {
		"id": Sessao.id,
		"username": username,
		"password": senha
	})

	# Limpa os campos
	$nick.text = ""
	$senha.text = ""

# Exibe painel de erro animado
func show_erro(texto: String) -> void:
	var painel = $show_erro
	painel.visible = true
	painel.get_node("label_mensagem").text = texto
	painel.modulate.a = 0.0
	painel.position.y = 20

	painel.get_node("AnimationPlayer").play("aparecer")
	painel.get_node("TimerErro").start()

# Oculta o painel de erro após timeout
func _on_timer_erro_timeout() -> void:
	var painel = $show_erro
	painel.get_node("AnimationPlayer").play("desaparecer")
	await painel.get_node("AnimationPlayer").animation_finished
	painel.visible = false
