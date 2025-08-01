extends Area2D

@onready var label_nome = $token/nome
@onready var imagem_fundo = $imagem_fundo
@onready var sprite_token = $token
@onready var label_nivel = $token/nivel

func _ready():
	if Global.personagem_selecionado.is_empty():
		push_error("Nenhum personagem selecionado.")
		return

	var dados = Global.personagem_selecionado[0]

	# Nome
	if label_nome:
		label_nome.text = str(dados["nome"]) if "nome" in dados else "Sem Nome"

	# Imagem de fundo
	if imagem_fundo and imagem_fundo is Sprite2D:
		imagem_fundo.texture = dados["imagem"] if "imagem" in dados else null
		imagem_fundo.region_enabled = true
		imagem_fundo.region_rect = dados["imagem_position"] if "imagem_position" in dados else Rect2()

	# Token
	if sprite_token and sprite_token is Sprite2D:
		sprite_token.texture = dados["token"] if "token" in dados else null
		sprite_token.region_enabled = true
		sprite_token.region_rect = dados["token_position"] if "token_position" in dados else Rect2()

	# Nível
	if label_nivel:
		label_nivel.text = "Nv. " + str(dados["nivel"]) if "nivel" in dados else "Nv. 1"
