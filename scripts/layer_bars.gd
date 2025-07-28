extends Node2D

@onready var barra_vermelha := $bar_vida/bar_vida2  # Sprite2D
@onready var barra_branca := $bar_vida              # Sprite2D

var vida_atual := 100
var vida_maxima := 100
var vida_alvo := 100
var velocidade := 1.0  # unidades de scale por segundo

func atualizar(nova_vida, nova_vida_maxima):
	vida_maxima = nova_vida_maxima
	vida_atual = nova_vida
	
	var percent := vida_atual / vida_maxima
	barra_vermelha.scale.x = percent
	vida_alvo = vida_atual

func receber_dano(valor):
	vida_atual = max(vida_atual - valor, 0)
	vida_alvo = vida_atual  # para animação suave da barra branca
	# Atualiza a barra vermelha imediatamente
	var percent := vida_atual / vida_maxima
	barra_vermelha.scale.x = percent

func _process(delta):
	var percent_atual = barra_branca.scale.x
	var percent_alvo = vida_alvo / vida_maxima
	
	if percent_atual > percent_alvo:
		percent_atual = max(percent_alvo, percent_atual - velocidade * delta)
		barra_branca.scale.x = percent_atual
	elif percent_atual < percent_alvo:
		barra_branca.scale.x = percent_alvo
