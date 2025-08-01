extends Panel

var ultimo_tempo_clique := 0.0
var intervalo_duplo_clique := 0.3 # segundos
var dentro = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if dentro:
			$slots_selecao/selecionar2.visible = true
			Global.selecionado_slots_selecao = self.name
			Global.selecionado_slots_estado = $slots_selecao/organizador/nome.text
			

			# Obtém dados reais do slot
			var imagem_node = $slots_selecao/organizador/imagem_fundo
			var token_node = $slots_selecao/organizador/token
			var nivel_raw = $slots_selecao/organizador/Nivel.text.strip_edges()
			var nivel = int(nivel_raw.replace("Nv.", "").strip_edges())
			var nome_texto = $slots_selecao/organizador/nome.text

			Global.personagem_selecionado.assign([ {
				"nome": nome_texto,
				"imagem": imagem_node.texture,
				"imagem_position": imagem_node.region_rect,
				"token": token_node.texture,
				"token_position": token_node.region_rect,
				"nivel": nivel
			}])

		else:
			$slots_selecao/selecionar2.visible = false


func _on_panel_mouse_entered() -> void:
	$slots_selecao/selecionar.visible = true
	dentro = true

func _on_panel_mouse_exited() -> void:
	$slots_selecao/selecionar.visible = false
	dentro = false
