extends PanelContainer

var dentro = false
func _on_mouse_entered() -> void:
	dentro = true
	$"../../../../../../../descricao_racas".visible = true

	$"../../../../../../../descricao_racas/ColorRect".visible = true
	$"../icone_seleção".visible = true
	#$"../../../../../../fundo/preview".visible = true
	$"../../../../../../../descricao_racas/nome_raca/personagem".texture = $"../imagem".texture
	$"../../../../../../../descricao_racas/nome_raca/personagem".region_rect = $"../imagem".region_rect
	


func _on_mouse_exited() -> void:
	dentro = false
	$"../icone_seleção".visible = false
	$"../../../../../../../descricao_racas/nome_raca/personagem".texture = null
	$"../../../../../../../descricao_racas/ColorRect".visible = false
	#$"../../../../../../fundo/preview".visible = false
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and dentro:
		Global.alvo_selecionado = "personagem"
		Global.raça_selecionado = $"..".name.capitalize()
		#print("dnkdsskimdsjdsnmdksmkdmsmkdsdmk")
		Global.imagem_apresentacao_personagem = $"../imagem".texture
		Global.imagem_apresentacao_personagem_propocao = $"../imagem".region_rect
	
