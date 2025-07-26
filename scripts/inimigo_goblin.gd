extends Node2D

@onready var ataque_timer := Timer.new()

var alvo: Node2D = null
var dano := 10
var tempo_entre_ataques := 1.5  # em segundos

func _ready():
	# Configura o timer de ataque
	add_child(ataque_timer)
	ataque_timer.wait_time = tempo_entre_ataques
	ataque_timer.one_shot = false
	ataque_timer.timeout.connect(_on_ataque_timeout)

	# Conecta os sinais de detecção de corpo
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("jogador"):
		alvo = body
		ataque_timer.start()
		print("🎯 Jogador no alcance. Iniciando ataque.")

func _on_body_exited(body):
	if body == alvo:
		alvo = null
		ataque_timer.stop()
		print("🚪 Jogador saiu do alcance. Ataque pausado.")

func _on_ataque_timeout():
	if alvo and alvo.is_inside_tree():
		if alvo.has_method("receber_dano"):
			alvo.receber_dano(dano)
			print("💥 Ataque! Dano causado: %d" % dano)
		else:
			print("⚠️ O alvo não possui o método 'receber_dano'.")
	else:
		ataque_timer.stop()
