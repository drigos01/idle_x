extends Node2D

var aberto := false
var saiu := false
var aberto2 := false
var saiu2 := false
var esperar_fechar2 := false  # Só fecha depois de sair e entrar novamente
var esperar_fechar := false  # Só fecha depois de sair e entrar novamente
var anim = "personagem_layer_abrir"
var total_disponivel = Global.valor_total_distribuir_criacao_personagem
var usado = Global.pontos_usados  # suponha que você armazena os pontos usados aqui
#var aberto = false
func _process(delta: float) -> void:
	$layer/HBoxContainer/Panel2/layer_atributos/valor_atributos.text = "%d/%d" % [usado, Global.pontos_usados]

func _on_menos_pressed() -> void:
	$layer/HBoxContainer/Panel2/layer_atributos/ScrollContainer/pericias_name/Panel/nome_layer4
	


func _on_mais_pressed() -> void:
	pass # Replace with function body.



#func _on_panel_container_2_mouse_entered() -> void:
	#if aberto:
		#$AnimationPlayer.play_backwards("personagem_layer_abrir")
		#Global.descricao_raca = ""
		#aberto = false


##
#func _on_panel_container_2_mouse_exited() -> void:
	#if aberto:
		#$AnimationPlayer.play_backwards("personagem_layer_abrir")
		#Global.descricao_raca = ""
		#aberto = false


#func _on_panel_container_mouse_entered() -> void:
	#$AnimationPlayer2.play("token_abrir")



#
#func _on_panel_container_2_mouse_exited() -> void:
	#$AnimationPlayer2.play_backwards("token_abrir")
	
	
func show_erro(texto: String, cor_fundo: Color = Color8(255, 0, 0)) -> void:
	var label = $show_erro/show_erro/label_mensagem
	label.text = texto
	label.self_modulate = Color.WHITE
#
	var painel = $show_erro/show_erro/ColorRect
	painel.add_theme_color_override("panel", cor_fundo)
#
	$show_erro.visible = true
	$show_erro.modulate.a = 1.0
	$show_erro.position.y = 20

	$show_erro/show_erro/AnimationPlayer.play("aparecer")
#
	if $show_erro/show_erro/TimerErro.is_stopped():
		$show_erro/show_erro/TimerErro.stop()
	$show_erro/show_erro/TimerErro.wait_time = 3.0
	$show_erro/show_erro/TimerErro.start()


func _on_area_slot_mouse_entered() -> void:
	if aberto2:
		$AnimationPlayer2.play_backwards("token_abrir")
	if not aberto:
		$layer/layer_raca_per.visible = true
		
		$AnimationPlayer.play("personagem_layer_abrir")
		aberto = true
		#saiu = false
		#esperar_fechar = true  # Agora vamos esperar a próxima entrada pra fechar
	elif aberto and saiu:
		# Agora sim, fecha — pois já saiu e voltou
		$AnimationPlayer.play_backwards("personagem_layer_abrir")
		Global.descricao_raca = ""
		aberto = false
		saiu = false
		esperar_fechar = false  # Resetar


func _on_area_slot_mouse_exited() -> void:
	print("fora")
	if aberto:
		# Só marca que saiu, não fecha ainda
		saiu = true


func _on_area_slot_2_mouse_entered() -> void:
	if aberto:
		$layer/layer_raca_per.visible = false
		$AnimationPlayer.play_backwards("personagem_layer_abrir")
		Global.descricao_raca = ""
		aberto = false
		saiu = false
		esperar_fechar = false  # Resetar

func _on_area_slot_3_mouse_entered() -> void:
	if aberto:
		$layer/layer_raca_per.visible = false
		$AnimationPlayer.play_backwards("personagem_layer_abrir")
		Global.descricao_raca = ""
		aberto = false
		saiu = false
		esperar_fechar = false  # Resetar

func _on_area_slot_4_mouse_entered() -> void:
	if aberto:
		$layer/layer_raca_per.visible = false
		$AnimationPlayer.play_backwards("personagem_layer_abrir")
		Global.descricao_raca = ""
		aberto = false
		saiu = false
		esperar_fechar = false  # Resetar


func _on_area_slot_5_mouse_entered() -> void:
	if aberto:
		$layer/layer_raca_per.visible = false
		$AnimationPlayer.play_backwards("personagem_layer_abrir")
		Global.descricao_raca = ""
		aberto = false
		saiu = false
		esperar_fechar = false  # Resetar


func _on_area_slot_token_mouse_entered() -> void:
	if aberto:
		$AnimationPlayer2.play_backwards("token_abrir")
	if not aberto2:
		$layer/layer_raca_per2.visible = true
		
		$AnimationPlayer2.play("token_abrir")
		aberto2 = true
		#saiu = false
		#esperar_fechar = true  # Agora vamos esperar a próxima entrada pra fechar
	elif aberto2 and saiu2:
		# Agora sim, fecha — pois já saiu e voltou
		$AnimationPlayer2.play_backwards("token_abrir")
		Global.descricao_raca = ""
		aberto2 = false
		saiu2 = false
		esperar_fechar2 = false  # Resetar


func _on_area_slot_token_2_mouse_entered() -> void:
	if aberto2:
		$layer/layer_raca_per2.visible = false
		$AnimationPlayer2.play_backwards("token_abrir")
		Global.descricao_raca = ""
		aberto2 = false
		saiu2 = false
		esperar_fechar2 = false  # Resetar


func _on_area_slot_token_3_mouse_entered() -> void:
	if aberto2:
		$layer/layer_raca_per2.visible = false
		$AnimationPlayer2.play_backwards("token_abrir")
		Global.descricao_raca = ""
		aberto2 = false
		saiu2 = false
		esperar_fechar2 = false  # Resetar


func _on_area_slot_token_4_mouse_entered() -> void:
	if aberto2:
		$layer/layer_raca_per2.visible = false
		$AnimationPlayer2.play_backwards("token_abrir")
		Global.descricao_raca = ""
		aberto2 = false
		saiu2 = false
		esperar_fechar2 = false  # Resetar


func _on_area_slot_token_mouse_exited() -> void:
	print("fora")
	if aberto2:
		# Só marca que saiu, não fecha ainda
		saiu2 = true
	
