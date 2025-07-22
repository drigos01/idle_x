extends Node2D


@onready var slot_mensagem_scene := preload("res://cenas/mensagem_slot.tscn")
@onready var container_mensagens := $fundo_chat/ScrollContainer/VBoxContainer  # ajuste esse caminho conforme sua UI


func _ready():
	Socket.connect("server_receive", get_message) 

func get_message(flag, response):
	if flag != "get_message":
		return

	var novo_slot = slot_mensagem_scene.instantiate()

	# Define o apelido (nick)
	novo_slot.get_node("nick").text = response.get("username", "Desconhecido")

	# Adiciona o texto da mensagem
	novo_slot.get_node("texto").clear()
	#novo_slot.get_node("texto").append_text(response.get("chat_enviar", ""))
	novo_slot.get_node("texto").text = (response.get("message", ""))
	print(response)

	# Exibe na tela (adicione ao container visível)
	#$fundo_chat/scroll/caixa_mensagens.add_child(novo_slot)

	

	container_mensagens.add_child(novo_slot)
	

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_ENTER, KEY_KP_ENTER:
				var chat_enviar = $fundo_chat/enviar_botao/chat_global.text
				Socket.enviar_json("enviar_mensagem_chat", {id = Sessao.id, chat_enviar = chat_enviar})
				$fundo_chat/enviar_botao/chat_global.text = ""
			KEY_E:
				print("🟢 Tecla E pressionada")

func _on_enviar_botao_pressed() -> void:
	var chat_enviar = $fundo_chat/enviar_botao/chat_global.text
	Socket.enviar_json("enviar_mensagem_chat", {id = Sessao.id, chat_enviar = chat_enviar})
	$fundo_chat/enviar_botao/chat_global.text = ""
	

	pass # Replace with function body.
