extends Node

signal server_receive(flag: String, response, Dicionary)

var socket := WebSocketPeer.new()
var connected = false

func _ready():
	conectar()

func conectar():
	var url = "wss://accurate-reasonably-egret.ngrok-free.app/"
	socket.connect_to_url(url)
	print("🔌 Conectando ao servidor:", url)
	
func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_P:
		print("🔁 Reconectando ao apertar E...")
		conectar()
		
func _process(_delta):
	if socket:
		socket.poll()

		var state = socket.get_ready_state()
		if state == WebSocketPeer.STATE_OPEN and !connected:
			connected = true
			print("✅ Conectado com sucesso ao WebSocket!")

		elif state == WebSocketPeer.STATE_CLOSED and connected:
			connected = false
			print("❌ WebSocket desconectado.")

		# Só processa mensagens se estiver conectado
		if connected:
			while socket.get_available_packet_count() > 0:
				var raw_msg = socket.get_packet().get_string_from_utf8()
				var result = JSON.parse_string(raw_msg)

				if typeof(result) == TYPE_DICTIONARY:
					emit_signal("server_receive", result.flag, result.response)
				else:
					print("⚠️ Mensagem recebida não é JSON válido:", raw_msg)

func enviar_json(flag: String, data: Dictionary) -> void:
	if socket and socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		var pacote = {
			"flag": flag,
			"data": data
		}
		var json_string = JSON.stringify(pacote)
		socket.send_text(json_string)
		#print("📤 Enviado:", json_string)
	else:
		print("⚠️ WebSocket não está conectado.")
