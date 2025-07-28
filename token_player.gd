extends CharacterBody2D

@export var controle_manual := false
@export var alcance_ataque := 60.0
@export var intervalo_ataque := 1.0
@export var tipo_ataque := "corpo" # ou "distancia"

@onready var timer_ataque: Timer = Timer.new()
@onready var token_player: Node2D = $token_player

var destino: Vector2
var mover := false
var velocidade_maxima := 500.0
var destino_pendente: Vector2
var mouse_pressionado := false
var tempo_marcador := 0.0
var inimigo_alvo: Node2D = null

func _ready():
	destino = global_position
	Global.mouse_sobre_chat = false
	
	add_child(timer_ataque)
	timer_ataque.wait_time = intervalo_ataque
	timer_ataque.one_shot = false
	timer_ataque.timeout.connect(_atacar)
	timer_ataque.start()

func _input(event: InputEvent) -> void:
	if controle_manual:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and not Global.mouse_sobre_chat:
				mouse_pressionado = true
				destino_pendente = get_global_mouse_position()
			elif not event.pressed:
				mouse_pressionado = false
				destino = destino_pendente
				mover = true
				mostrar_indicador(destino)

func _process(delta: float) -> void:
	if controle_manual:
		if mouse_pressionado:
			destino_pendente = get_global_mouse_position()
			var direcao_mouse = destino_pendente - global_position
			token_player.rotation = lerp_angle(token_player.rotation, direcao_mouse.angle(), delta * 10)
			tempo_marcador -= delta
			if tempo_marcador <= 0:
				mostrar_indicador(destino_pendente)
				tempo_marcador = 0.02
	else:
		# Modo automático: procura inimigo próximo
		var inimigos = get_tree().get_nodes_in_group("inimigos")
		var mais_proximo = null
		var menor_dist = INF
		for inimigo in inimigos:
			var dist = global_position.distance_to(inimigo.global_position)
			if dist < menor_dist:
				menor_dist = dist
				mais_proximo = inimigo
		if mais_proximo and menor_dist <= 300:
			inimigo_alvo = mais_proximo
			destino = inimigo_alvo.global_position
			mover = true

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
	move_and_slide()

func mostrar_indicador(posicao: Vector2) -> void:
	var marcador = Sprite2D.new()
	marcador.texture = preload("res://imagens/layer/token-border-collection-v0-8pv4nqo221ja1.png")
	marcador.global_position = posicao
	marcador.scale = Vector2(0.09, 0.09)
	get_tree().current_scene.add_child(marcador)

	await get_tree().create_timer(0.3).timeout
	if marcador: marcador.queue_free()

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

func atirar_projetil(destino: Vector2) -> void:
	var proj = preload("res://cenas/flecha.tscn").instantiate()
	proj.global_position = global_position
	proj.direcao = (destino - global_position).normalized()
	get_tree().current_scene.add_child(proj)
