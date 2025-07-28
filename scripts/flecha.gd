extends Node2D

@export var velocidade := 250.0
var direcao := Vector2.ZERO

@onready var detector := $Detector

func _ready():
	# Gira na direção do movimento
	if direcao.length() > 0:
		rotation = direcao.angle()

	# Conecta detecção de colisão
	detector.connect("area_entered", Callable(self, "_on_area_entered"))

func _physics_process(delta):
	position += direcao.normalized() * velocidade * delta

	# Remove se sair da tela
	if not get_viewport_rect().has_point(global_position):
		queue_free()

func _on_area_entered(area):
	# Se quiser só colidir com inimigos, use:
	# if area.is_in_group("inimigo"):
	#     queue_free()
	queue_free()
