extends Node2D

func _process(delta: float) -> void:
	var textura = Global.imagem_apresentacao_token
	var rect: Rect2 = Global.imagem_apresentacao_token_propocao

	if typeof(textura) == TYPE_OBJECT and textura is Texture:
		var sprite = $perosonagem/token2
		sprite.texture = textura
		sprite.region_enabled = true
		sprite.region_rect = rect
	else:
		print("Objeto inválido ou textura ausente:", textura)
