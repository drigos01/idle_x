extends Node2D

func _process(delta: float) -> void:
	if Global.show_erro:
		print("etapa_1")
		if Global.valor_show_erro_passar != "":
			print("jnxjsnxnsxnjs")
			#show_erro(Global.valor_show_erro_passar, Color(1, 0, 0))  # vermelho puro
		#else:
			#show_erro("Valor não atribuido.", Color8(0, 200, 0))
		
func show_erro(texto: String, cor_fundo: Color = Color8(255, 0, 0)) -> void:
	var label = $label_mensagem
	label.text = texto
	label.self_modulate = Color.WHITE
#
	var painel = $ColorRect
	painel.add_theme_color_override("panel", cor_fundo)
#
	$".".visible = true
	$".".modulate.a = 1.0
	$".".position.y = 20

	$AnimationPlayer.play("aparecer")
#
	if $TimerErro.is_stopped():
		$TimerErro.stop()
	$TimerErro.wait_time = 3.0
	$TimerErro.start()
