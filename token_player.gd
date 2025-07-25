extends CharacterBody2D

var destino: Vector2
var mover := false
var velocidade_maxima := 500.0
var destino_pendente: Vector2
var mouse_pressionado := false
var tempo_marcador := 0.0

func _ready():
	destino = global_position
	Global.mouse_sobre_chat = false

func _input(event: InputEvent) -> void:
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
	if mouse_pressionado:
		# Atualiza destino visual constantemente
		destino_pendente = get_global_mouse_position()

		# Inclina o token em direção ao mouse
		var direcao_mouse = destino_pendente - global_position
		$token_player.rotation = lerp_angle($token_player.rotation, direcao_mouse.angle(), delta * 10)


		# Efeito visual periódico
		tempo_marcador -= delta
		if tempo_marcador <= 0:
			mostrar_indicador(destino_pendente)
			tempo_marcador = 0.02  # Frequência de indicador visual

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

func mostrar_indicador(posicao: Vector2):
	var marcador = Sprite2D.new()
	marcador.texture = preload("res://imagens/layer/token-border-collection-v0-8pv4nqo221ja1.png")
	marcador.global_position = posicao
	marcador.scale = Vector2(0.09, 0.09)
	get_tree().current_scene.add_child(marcador)

	await get_tree().create_timer(0.3).timeout
	if marcador: marcador.queue_free()
