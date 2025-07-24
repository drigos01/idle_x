extends Node2D

func _ready():
	#get_my_id
	Socket.connect("server_receive", _session_id)
	Socket.connect("server_receive", get_user) # logged

func _session_id(flag, response):
	if flag != "get_my_id": return
	Sessao.id = response.id

func get_user(flag, response):
	if flag != "registered": return
	#print(response)
	#Global.username = response.username
	#Global.email = response.email
	#show_erro(response.message)
	if !response.has("status") or response.status != 201:
		return
	show_erro(response.message)
	
	var label = $show_erro/label_mensagem
	label.text = response.message # Ou qualquer texto de erro que quiser
	label.add_theme_color_override("font_color", Color.GREEN)

	#get_tree().change_scene_to_file("res://cenas/mundo_1.tscn")
	#print(Global.username, Global.email)

func _on_enviar_pressed() -> void:
	var username = $nick.text.strip_edges()
	var email = $email.text.strip_edges()
	var senha = $senha.text.strip_edges()

	# Validação: username
	if username == "":
		show_erro("O nome de usuário não pode estar vazio.")
		return
	if username.length() < 3 or username.length() > 13:
		show_erro("O nome de usuário deve ter entre 3 e 13 letras.")
		return

	# Validação: email
	if email == "":
		show_erro("O email não pode estar vazio.")
		return

	# Validação: senha
	if senha == "":
		show_erro("A senha não pode estar vazia.")
		return
	if senha.length() < 9 or senha.length() > 31:
		show_erro("A senha deve ter entre 9 e 31 caracteres.")
		return

	# Enviar dados para o servidor
	Socket.enviar_json("registering", {
		"id": Sessao.id,
		"username": username,
		"email": email,
		"password": senha
	})

	# Limpar os campos
	$nick.text = ""
	$email.text = ""
	$senha.text = ""
	
func show_erro(texto: String) -> void:
	$show_erro/label_mensagem.text = texto
	
	$show_erro.visible = true
	$show_erro.modulate.a = 0.0
	$show_erro.position.y = 20

	$show_erro/AnimationPlayer.play("aparecer")
	$show_erro/TimerErro.start()

func _on_timer_erro_timeout() -> void:
	$show_erro/AnimationPlayer.play("desaparecer")
	await $show_erro/AnimationPlayer.animation_finished
	$show_erro.visible = false

#
#func _on_timer_erro_timeout():
	#var painel = $show_erro
	#var tween = $show_erro/TweenErro
#
	#tween.kill()
	#tween.tween_property(painel, "modulate:a", 0.0, 0.3, Tween.TRANS_SINE, Tween.EASE_IN)
	#tween.tween_property(painel, "position:y", 20.0, 0.3, Tween.TRANS_SINE, Tween.EASE_IN)
	#await tween.finished
	#painel.visible = false
