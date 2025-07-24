extends CharacterBody2D

var destino: Vector2
var mover := false
var velocidade_maxima := 500.0

func _ready():
	destino = global_position
	Global.mouse_sobre_chat = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not Global.mouse_sobre_chat:
			mover = true
			destino = get_global_mouse_position()
			print("🖱️ Iniciando movimento")

func _physics_process(delta: float) -> void:
	# Atualiza destino enquanto botão pressionado e não estiver sobre chat
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not Global.mouse_sobre_chat:
		destino = get_global_mouse_position()
		mover = true

	var direcao = destino - global_position
	var distancia = direcao.length()

	if mover:
		if distancia > 2.0:
			# Acelera suavemente para o destino
			velocity = velocity.lerp(direcao.normalized() * velocidade_maxima, 0.2)
		else:
			# Desacelera suavemente ao se aproximar
			velocity = velocity.lerp(Vector2.ZERO, 0.2)
			# Só para completamente se estiver bem lento e muito perto
			if velocity.length() < 2.0:
				mover = false
	else:
		# Garante que a velocidade vá suavemente para zero
		velocity = velocity.lerp(Vector2.ZERO, 0.1)

	move_and_slide()
