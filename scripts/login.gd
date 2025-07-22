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
	var nick_input = $login/VBoxContainer/inventario/nick
	var username = nick_input.text
	var email = $login/VBoxContainer/inventario3/email.text
	var senha = $login/VBoxContainer/inventario2/senha.text

	Socket.enviar_json("logging", {id = Sessao.id, username = username, email = email, senha = senha})
	$login/VBoxContainer/inventario/nick.text = ""
	$login/VBoxContainer/inventario3/email.text = ""
	$login/VBoxContainer/inventario2/senha.text = ""
