extends CharacterBody2D

var vida := 100
var vida_maxima := 100

@export var controle_manual := false
@export var alcance_ataque := 60.0
@export var distancia_parada := 400.0
@export var distancia_corpo := 40.0
@export var intervalo_ataque := 1.0
@export var tipo_ataque := "distancia"  # "distancia" ou "corpo"

@onready var timer_ataque: Timer = Timer.new()
@onready var token_player: Node2D = $token_player2
@onready var barra_vida := $camera/Camera2D/layer_bars

var level = true

var inimigos_indicados := {}
var destino: Vector2
var mover := false
var velocidade_maxima := 500.0
var destino_pendente: Vector2
var mouse_pressionado := false
var tempo_marcador := 0.0
var inimigo_alvo: Node2D = null
var marcador_atual: Sprite2D = null

func _ready():
	if level:
		$camera.scale = Vector2(2.0, 2.0)
		$camera/Camera2D.zoom = Vector2(0.5, 0.5)
	else:
		$Camera2D.zoom = Vector2(1, 1)

	Global.jogador[name] = self
	destino = global_position
	Global.mouse_sobre_chat = false

	set_process_input(true)

	add_child(timer_ataque)
	timer_ataque.wait_time = intervalo_ataque
	timer_ataque.one_shot = false
	timer_ataque.timeout.connect(_atacar)

func _input(event: InputEvent) -> void:
	if not controle_manual:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and not Global.mouse_sobre_chat:
			mouse_pressionado = true
			destino_pendente = get_global_mouse_position()
		elif not event.pressed and mouse_pressionado:
			mouse_pressionado = false
			destino = destino_pendente
			mover = true
			mostrar_indicador(destino)

func _process(delta: float) -> void:
	if not controle_manual:
		if mouse_pressionado:
			destino_pendente = get_global_mouse_position()
			var direcao_mouse = destino_pendente - global_position
			token_player.rotation = lerp_angle(token_player.rotation, direcao_mouse.angle(), delta * 10)
			tempo_marcador -= delta
			if tempo_marcador <= 0:
				mostrar_indicador(destino_pendente)
				tempo_marcador = 0.02
		else:
			if inimigo_alvo == null or not is_instance_valid(inimigo_alvo):
				procurar_inimigo()
			else:
				var dist = global_position.distance_to(inimigo_alvo.global_position)
				if dist > alcance_ataque:
					var dir = (inimigo_alvo.global_position - global_position).normalized()
					if tipo_ataque == "distancia":
						destino = inimigo_alvo.global_position - dir * distancia_parada
					else:
						destino = inimigo_alvo.global_position - dir * distancia_corpo
					mover = true

	else:
		procurar_inimigo()

func procurar_inimigo():
	var inimigos = get_tree().get_nodes_in_group("inimigos")
	var mais_proximo = null
	var menor_dist = INF

	for inimigo in inimigos:
		var dist = global_position.distance_to(inimigo.global_position)
		if dist < menor_dist:
			menor_dist = dist
			mais_proximo = inimigo

	if mais_proximo and menor_dist <= 900:
		inimigo_alvo = mais_proximo
		var dir = (inimigo_alvo.global_position - global_position).normalized()
		if tipo_ataque == "distancia":
			destino = inimigo_alvo.global_position - dir * distancia_parada
		else:
			destino = inimigo_alvo.global_position
		mover = menor_dist > alcance_ataque

		if not inimigos_indicados.has(inimigo_alvo):
			mostrar_indicador(inimigo_alvo.global_position)
			inimigos_indicados[inimigo_alvo] = true

	if inimigo_alvo and not timer_ataque.is_stopped():
		timer_ataque.start()
	elif inimigo_alvo == null:
		timer_ataque.stop()

func _physics_process(delta: float) -> void:
	if mover:
		var direcao = destino - global_position
		var distancia = direcao.length()
		if distancia > 5.0:
			velocity = velocity.lerp(direcao.normalized() * velocidade_maxima, 0.1)
		else:
			velocity = velocity.lerp(Vector2.ZERO, 0.1)
			if velocity.length() < 5.0:
				velocity = Vector2.ZERO
				mover = false
	else:
		velocity = velocity.lerp(Vector2.ZERO, 0.2)

	move_and_slide()

func mostrar_indicador(posicao: Vector2) -> void:
	if marcador_atual and marcador_atual.is_inside_tree():
		marcador_atual.queue_free()

	marcador_atual = Sprite2D.new()
	marcador_atual.texture = preload("res://imagens/layer/token-border-collection-v0-8pv4nqo221ja1.png")
	marcador_atual.global_position = posicao
	marcador_atual.scale = Vector2(0.09, 0.09)
	get_tree().current_scene.add_child(marcador_atual)

	await get_tree().create_timer(0.8).timeout

	if marcador_atual and marcador_atual.is_inside_tree():
		marcador_atual.queue_free()
		marcador_atual = null

func _atacar() -> void:
	if inimigo_alvo and is_instance_valid(inimigo_alvo):
		var dist = global_position.distance_to(inimigo_alvo.global_position)
		if dist <= alcance_ataque:
			token_player.look_at(inimigo_alvo.global_position)
			match tipo_ataque:
				"corpo":
					print("🔪 Atacando corpo a corpo:", inimigo_alvo.name)
					if inimigo_alvo.has_method("receber_dano"):
						inimigo_alvo.receber_dano(10)
				"distancia":
					print("🏹 Atirando à distância em:", inimigo_alvo.name)
					atirar_projetil(inimigo_alvo.global_position)
	else:
		inimigo_alvo = null
		timer_ataque.stop()

func atirar_projetil(destino: Vector2) -> void:
	var proj = preload("res://cenas/flecha.tscn").instantiate()
	proj.global_position = global_position
	proj.direcao = (destino - global_position).normalized()
	get_tree().current_scene.add_child(proj)

func _exit_tree():
	Global.jogador.erase(name)
	
func levar_dano(valor):
	barra_vida.receber_dano(valor)
