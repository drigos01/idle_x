extends Node2D

var erro_em_exibicao := false
var animacao_rodando := false
var texto_atual := ""

func _process(_delta: float) -> void:
	if Global.show_erro and not erro_em_exibicao and not animacao_rodando:
		if Global.valor_show_erro_passar != "":
			show_erro(Global.valor_show_erro_passar, Color(1, 0, 0))
		else:
			show_erro("Valor não atribuído.", Color8(0, 200, 0))

func show_erro(texto: String, cor_fundo: Color = Color8(255, 0, 0)) -> void:
	texto_atual = texto
	erro_em_exibicao = true
	animacao_rodando = true
	self.visible = true  # Garante visibilidade

	var label = $label_mensagem
	label.text = texto
	label.self_modulate = Color.WHITE

	var painel = $ColorRect
	painel.add_theme_color_override("panel", cor_fundo)

	# Interrompe "desaparecer" se necessário
	if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation == "desaparecer":
		$AnimationPlayer.stop()

	$AnimationPlayer.play("aparecer")

	# Reinicia o temporizador
	$TimerErro.stop()
	$TimerErro.wait_time = 3.0
	$TimerErro.start()

func _on_timer_erro_timeout() -> void:
	if self.visible:
		animacao_rodando = true
		$AnimationPlayer.play("desaparecer")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"aparecer":
			animacao_rodando = false

		"desaparecer":
			$label_mensagem.text = ""
			self.visible = false
			Global.show_erro = false
			Global.valor_show_erro_passar = ""
			erro_em_exibicao = false
			animacao_rodando = false
			texto_atual = ""
