extends Node2D

func _ready():
	#get_my_id
	Socket.connect("server_receive", _session_id)
	Socket.connect("server_receive", get_user) # logged

func _session_id(flag, response):
	if flag != "get_my_id": return
	Sessao.id = response.id

func get_user(flag, response):
	if flag != "logged": return
	#print(response)
	Global.username = response.username
	Global.email = response.email
	get_tree().change_scene_to_file("res://cenas/mundo_1.tscn")
	#print(Global.username, Global.email)


func _on_enviar_pressed() -> void:
	var nick_input = $nick.text
	var username = $nick.text
	var email = $email.text
	var senha = $senha.text

	Socket.enviar_json("logging", {id = Sessao.id, username = username, email = email, password = senha})
	#usarname, email = email, senha, = senha)
	$nick.text = ""
	$email.text = ""
	$senha.text = ""
