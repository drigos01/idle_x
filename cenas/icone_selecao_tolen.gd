extends PanelContainer


func _on_mouse_entered() -> void:
	$"../seleção_grande".visible = true
	$"../../../../../../fundo/preview".visible = true
	$"../../../../../../fundo/preview".texture = $"../imagem".texture
	$"../../../../../../fundo/preview".region_rect = $"../imagem".region_rect
	


func _on_mouse_exited() -> void:
	$"../seleção_grande".visible = false
	$"../../../../../../fundo/preview".visible = false
	
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if $"../seleção_grande".visible:
			Global.imagem_apresentacao_token = $"../imagem".texture
			Global.imagem_apresentacao_token_propocao = $"../imagem".region_rect
			print(Global.imagem_apresentacao_token)
			pass
		
