extends Panel

var ultimo_tempo_clique := 0.0
var intervalo_duplo_clique := 0.3  # segundos
var dentro = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#Global.selecionado_slots_selecao = self
		#print("Slot selecionado:", self.name)
		var tempo_atual = Time.get_ticks_usec() / 1_000_000.0
		var nome_node = $slots_selecao/organizador/nome.text

		#if nome_node.strip_edges() == "":
			#printerr("Nó 'nome' não encontrado.")
			#Global.selecionado_slots_selecao = "vazio"  # Armazena vazio mesmo assim
			#print("vazio")
			#return

		#var texto = $slots_selecao/organizador/nome.text
		#Global.selecionado_slots_selecao = "clique"
		#print("cheio")
		

		if tempo_atual - ultimo_tempo_clique < intervalo_duplo_clique:
			print("Clique duplo detectado!")
			get_tree().change_scene_to_file("res://cenas/criacao_de_personagem.tscn")
		else:
			if dentro:
				$slots_selecao/selecionar2.visible = true
				Global.selecionado_slots_selecao = self.name
				print(Global.selecionado_slots_selecao)
				Global.selecionado_slots_estado = $slots_selecao/organizador/nome.text
				print(Global.selecionado_slots_estado)
				
			else:
				$slots_selecao/selecionar2.visible = false
			#print("Clique simples.")

		ultimo_tempo_clique = tempo_atual

func _on_panel_mouse_entered() -> void:
	$slots_selecao/selecionar.visible = true
	dentro = true

func _on_panel_mouse_exited() -> void:
	$slots_selecao/selecionar.visible = false
	dentro = false
