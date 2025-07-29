extends Node2D

var aberto := false
var saiu := false
var esperar_fechar := false

var aberto2 := false
var saiu2 := false
var esperar_fechar2 := false

var anim = "personagem_layer_abrir"

var total_disponivel = Global.valor_total_distribuir_criacao_personagem
var usado = Global.pontos_usados

func _process(delta: float) -> void:
	$layer/HBoxContainer/Panel2/layer_atributos/valor_atributos.text = "%d/%d" % [usado, Global.pontos_usados]

func _on_menos_pressed() -> void:
	$layer/HBoxContainer/Panel2/layer_atributos/ScrollContainer/pericias_name/Panel/nome_layer4

func _on_mais_pressed() -> void:
	pass

func show_erro(texto: String, cor_fundo: Color = Color8(255, 0, 0)) -> void:
	var label = $show_erro/show_erro/label_mensagem
	label.text = texto
	label.self_modulate = Color.WHITE

	var painel = $show_erro/show_erro/ColorRect
	painel.add_theme_color_override("panel", cor_fundo)

	$show_erro.visible = true
	$show_erro.modulate.a = 1.0
	$show_erro.position.y = 20
	$show_erro/show_erro/AnimationPlayer.play("aparecer")

	if $show_erro/show_erro/TimerErro.is_stopped():
		$show_erro/show_erro/TimerErro.stop()

	$show_erro/show_erro/TimerErro.wait_time = 3.0
	$show_erro/show_erro/TimerErro.start()

# Atualiza qual layer está visível com base nos abertos
func atualizar_visibilidade_layers() -> void:
	$layer/layer_raca_per.visible = aberto and not aberto2
	$layer/layer_raca_per2.visible = aberto2 and not aberto

# Funções auxiliares
func fechar_personagem_layer():
	$AnimationPlayer.play_backwards(anim)
	Global.descricao_raca = ""
	aberto = false
	saiu = false
	esperar_fechar = false
	atualizar_visibilidade_layers()

func fechar_token_layer():
	$AnimationPlayer2.play_backwards("token_abrir")
	Global.descricao_raca = ""
	aberto2 = false
	saiu2 = false
	esperar_fechar2 = false
	atualizar_visibilidade_layers()

# Entradas e saídas do slot personagem
func _on_area_slot_mouse_entered() -> void:
	if aberto2:
		$AnimationPlayer2.play_backwards("token_abrir")
		aberto2 = false

	if not aberto:
		aberto = true
		$AnimationPlayer.play(anim)
	elif saiu:
		fechar_personagem_layer()

	atualizar_visibilidade_layers()

func _on_area_slot_mouse_exited() -> void:
	if aberto:
		saiu = true
		$layer/personagem/descricao_racas.visible = false

# Slots que fecham personagem diretamente
func _on_area_slot_2_mouse_entered() -> void: fechar_personagem_layer()
func _on_area_slot_3_mouse_entered() -> void: fechar_personagem_layer()
func _on_area_slot_4_mouse_entered() -> void: fechar_personagem_layer()
func _on_area_slot_5_mouse_entered() -> void: fechar_personagem_layer()

# Entradas e saídas do slot token
func _on_area_slot_token_mouse_entered() -> void:
	if aberto:
		$AnimationPlayer.play_backwards(anim)
		aberto = false

	if not aberto2:
		aberto2 = true
		$AnimationPlayer2.play("token_abrir")
	elif saiu2:
		fechar_token_layer()

	atualizar_visibilidade_layers()

func _on_area_slot_token_mouse_exited() -> void:
	if aberto2:
		saiu2 = true

# Slots que fecham token diretamente
func _on_area_slot_token_2_mouse_entered() -> void: fechar_token_layer()
func _on_area_slot_token_3_mouse_entered() -> void: fechar_token_layer()
func _on_area_slot_token_4_mouse_entered() -> void: fechar_token_layer()
