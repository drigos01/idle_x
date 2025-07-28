extends Node2D

var anim = "personagem_layer_abrir"
var total_disponivel = Global.valor_total_distribuir_criacao_personagem
var usado = Global.pontos_usados  # suponha que você armazena os pontos usados aqui
func _process(delta: float) -> void:
	$layer/HBoxContainer/Panel2/layer_atributos/valor_atributos.text = "%d/%d" % [usado, Global.pontos_usados]

func _on_menos_pressed() -> void:
	$layer/HBoxContainer/Panel2/layer_atributos/ScrollContainer/pericias_name/Panel/nome_layer4
	


func _on_mais_pressed() -> void:
	pass # Replace with function body.


func _on_panel_container_mouse_entered() -> void:
	$AnimationPlayer.play("personagem_layer_abrir")



func _on_panel_container_mouse_exited() -> void:
	$AnimationPlayer.play_backwards("personagem_layer_abrir")


func _on_panel_container_2_mouse_entered() -> void:
	$AnimationPlayer2.play("token_abrir")




func _on_panel_container_2_mouse_exited() -> void:
	$AnimationPlayer2.play_backwards("token_abrir")
	
	
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
