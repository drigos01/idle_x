extends Node2D

@onready var ataque_timer: Timer = Timer.new()

var alvo: Node2D = null
var dano: int = 10
var tempo_entre_ataques: float = 1.5  # em segundos

func _ready():
	Global.inimigos[name] = self  # Usa o nome como chave
	# Adiciona e configura o Timer
	ataque_timer.wait_time = tempo_entre_ataques
	ataque_timer.one_shot = false
	ataque_timer.timeout.connect(_on_ataque_timeout)
	add_child(ataque_timer)

	# Conecta detecção de corpos (necessário que este nó tenha um CollisionShape2D + Area2D como filho)
	if has_signal("body_entered"):
		self.body_entered.connect(_on_body_entered)
	if has_signal("body_exited"):
		self.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):  # Verifica se é um jogador
		alvo = body
		ataque_timer.start()
		print("🎯 Jogador entrou no alcance. Ataque iniciado.")

func _on_body_exited(body: Node) -> void:
	if body == alvo:
		alvo = null
		ataque_timer.stop()
		print("🚪 Jogador saiu do alcance. Ataque parado.")

func _on_ataque_timeout() -> void:
	if not alvo or not alvo.is_inside_tree():
		ataque_timer.stop()
		return

	if alvo.has_method("receber_dano"):
		alvo.receber_dano(dano)
		print("💥 Ataque realizado! Dano: %d" % dano)
	else:
		print("⚠️ O alvo não possui o método 'receber_dano'.")
func _exit_tree():
	Global.inimigos.erase(name)
