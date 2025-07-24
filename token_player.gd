extends CharacterBody2D

var destino: Vector2
var mover := false
var velocidade_maxima := 500.0

func _ready():
	destino = global_position  # Começa parado no local atual
	Global.mouse_sobre_chat = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if Global.mouse_sobre_chat:
			destino = get_global_mouse_position()
			mover = true
			print("🖱️ Indo até:", destino)

func _physics_process(delta: float) -> void:
	if mover:
		var direcao = (destino - global_position)
		if direcao.length() > 5:
			velocity = direcao.normalized() * velocidade_maxima
		else:
			velocity = Vector2.ZERO
			mover = false
	else:
		velocity = Vector2.ZERO

	move_and_slide()
