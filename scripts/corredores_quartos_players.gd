extends Node2D

var online := false
var quantidade_alvo := 0.3
var velocidade_modulate := 2.0
var alpha_alvo = 1.0
const TOTAL_PORTAS := 12
var dentro_area = false
var portas: Array = []
var alvos_transparentes = {}
@onready var alvo := $parede_frontal5  # Substitua pelo nó que você quer afetar
var estado_portas = {}  # chave: porta, valor: bool (true = aberta, false = fechada)

@onready var painel = $portas_esquerda/ItensUteis/PainelClique  # seu painel Control

var mouse_no_painel = false

var usuarios_simulados = [
	{ "username": "Kael" }, { "username": "Luna" }, { "username": "Zorak" },
	{ "username": "Tina" }, { "username": "Hugo" }, { "username": "Nina" },
	{ "username": "Ryo" }, { "username": "Milo" }, { "username": "Kira" },
	{ "username": "Eddy" }, { "username": "Xan" }, { "username": "Ayla" }
]

func _ready():
	painel.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	painel.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	painel.connect("gui_input", Callable(self, "_on_gui_input"))

	coletar_portas_automatico()
	conectar_areas()
	atribuir_quartos_aleatorios()
	conectar_clicks_portas()

func _process(delta):
	pass
	#for porta in portas:
		#var alvo = porta.get_node("portas_esquerda")  # ou outro nó visual
		#if not alvo:
			#continue
		#var modulate_atual = alvo.modulate
		#var dentro = alvos_transparentes.get(porta, false)
		#if dentro:
			#alpha_alvo = quantidade_alvo
#
		#modulate_atual.a = lerp(modulate_atual.a, alpha_alvo, delta * velocidade_modulate)
		#alvo.modulate = modulate_atual
	#var modulate_atual = alvo.modulate
	
	# Define o alpha alvo baseado em dentro_area
	#var alpha_alvo = 1.0
	#if dentro_area:
		#alpha_alvo = quantidade_alvo
	#
	## Faz a transição suave do alpha
	#modulate_atual.a = lerp(modulate_atual.a, alpha_alvo, delta * velocidade_modulate)
	#alvo.modulate = modulate_atual
#
	#modulate_atual.a = lerp(modulate_atual.a, alpha_alvo, delta * velocidade_modulate)
	#alvo.modulate = modulate_atual


# 🔗 Conecta sinais de cada porta para detectar entrada/saída do player
func conectar_areas():
	for porta in portas:
		var area = porta.get_node_or_null("Area2D")
		if area:
			area.body_entered.connect(_on_area_body_entered.bind(porta))
			area.body_exited.connect(_on_area_body_exited.bind(porta))

# 🖱️ Conecta sinais para clique em cada porta
#func conectar_clicks_portas():
	#for porta in portas:
		#var area = porta.get_node_or_null("Area2D")
		#if area:
			#area.connect("input_event", self, "_on_porta_input_event", [porta])

# 💡 Responde à entrada do player
func _on_area_body_entered(body: Node, porta: Node):
	if body.name == "Player":
		alvos_transparentes[porta] = true

func _on_area_body_exited(body: Node, porta: Node):
	if body.name == "Player":
		alvos_transparentes[porta] = false

# 🏷️ Atribui nomes simulados às portas
func atribuir_quartos_aleatorios():
	var usuarios = usuarios_simulados.duplicate()
	usuarios.shuffle()

	for i in range(portas.size()):
		var label = portas[i].get_node_or_null("Label")
		if i < usuarios.size():
			var user = usuarios[i]
			portas[i].set_meta("destino_user", user.username)
			estado_portas[portas[i]] = false  # começa fechada
			if label:
				label.text = "Visitar: " + user.username
		else:
			portas[i].set_meta("destino_user", null)
			estado_portas[portas[i]] = false  # fechada
			if label:
				label.text = "Vazio"


# 🖱️ Responde ao clique numa porta
func _on_porta_input_event(viewport, event, shape_idx, porta):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		print("Clique detectado na porta:", porta.name)
		estado_portas[porta] = false  # default fechado

		# Alterna o estado da porta
		estado_portas[porta] = !estado_portas[porta]

		var destino_user = porta.get_meta("destino_user")
		var estado_texto = "Aberta" if estado_portas[porta] else "Fechada"

		if destino_user:
			mostrar_mensagem("Porta de " + str(destino_user) + " está " + estado_texto, Color8(0, 200, 0))
		else:
			mostrar_mensagem("Porta vazia está " + estado_texto, Color8(200, 0, 0))


# Função que mostra uma mensagem visual (ajuste conforme seu node)
func mostrar_mensagem(texto: String, cor: Color):
	Global.show_mensagem_alerta = texto
	#print("deu bommmmmmmmmmmmmmmmmmmmmmmmmm")
	#var player = get_tree().get_root().get_node("token_player2")
	#if player:
		#var label = player.get_node("$token_player2/show_notificacao")
		#label.text = texto
		#label.self_modulate = Color.WHITE
#
		##var painel = player.get_node("show_notificacao/ColorRect")
		##painel.add_theme_color_override("panel", cor)
#
		#var painel_root = player.get_node("show_notificacao")
		#painel_root.visible = true
		#painel_root.modulate.a = 1.0
		#painel_root.position.y = 20
#
		##var anim = player.get_node("show_notificacao/AnimationPlayer")
		##anim.play("aparecer")
#
		#var timer = player.get_node("$token_player2/show_notificacao/show_erro/TimerErro")
		#if timer.is_stopped():
			#timer.stop()
		#timer.wait_time = 3.0
		#timer.start()


func _on_area_2d_body_entered(body: Node2D) -> void:
	dentro_area = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	dentro_area = false
	
func coletar_recursivo(no):
	for filho in no.get_children():
		if filho is Node:
			if filho.has_node("Label"):
				portas.append(filho)
				alvos_transparentes[filho] = false
			coletar_recursivo(filho)

func coletar_portas_automatico():
	var pai_portas = $portas_esquerda
	portas.clear()
	alvos_transparentes.clear()
	coletar_recursivo(pai_portas)
	print("Total de portas encontradas: ", portas.size())
	
func _on_mouse_entered():
	mouse_no_painel = true
	print("Mouse entrou no painel")

func _on_mouse_exited():
	mouse_no_painel = false
	print("Mouse saiu do painel")

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if mouse_no_painel:
			print("Clique esquerdo no painel detectado")
			
func conectar_clicks_portas():
	for porta in portas:
		var painel = porta.get_node_or_null("PainelClique")
		if painel:
			painel.connect("gui_input", Callable(self, "_on_painel_gui_input").bind(porta))
			
func _on_painel_gui_input(event: InputEvent, porta):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:

		# Alterna estado da porta
		estado_portas[porta] = !estado_portas.get(porta, false)

		var destino_user = porta.get_meta("destino_user")
		var estado_texto = "Aberta" if estado_portas[porta] else "Fechada"

		print("Porta %s está %s" % [porta.name, estado_texto])
