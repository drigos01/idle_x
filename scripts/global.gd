extends Node
var username = ""
var email = ""
var senha = ""
var mouse_sobre_chat = true
var players = {}
var show_mensagem_alerta = ""

var inimigos: Dictionary = {}
var jogador: Dictionary = {}

var valor_total_distribuir_criacao_personagem = 5
var pontos_usados = 5
var show_erro = false
var valor_show_erro_passar = ""
func _ready():
	# Opcional: inicializa vazio
	inimigos.clear()
	jogador.clear()
	
	
