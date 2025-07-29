extends PanelContainer

var dentro = false
func _on_mouse_entered() -> void:
	dentro = true
	$"../../../../../../fundo".visible = true
	$"../seleção_grande".visible = true
	$"../../../../../../fundo/preview".visible = true
	$"../../../../../../fundo/preview".texture = $"../imagem".texture
	$"../../../../../../fundo/preview".region_rect = $"../imagem".region_rect
	


func _on_mouse_exited() -> void:
	dentro = false
	$"../seleção_grande".visible = false
	$"../../../../../../fundo/preview".visible = false
	$"../../../../../../fundo".visible = false
	
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and dentro:
		if $"../seleção_grande".visible:
			Global.alvo_selecionado = "token"
			Global.imagem_apresentacao_token = $"../imagem".texture
			Global.imagem_apresentacao_token_propocao = $"../imagem".region_rect
			print(Global.imagem_apresentacao_token)
			pass
		
