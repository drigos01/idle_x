extends Node2D

func _process(delta: float) -> void:
	# Atualiza apenas o que foi clicado
	match Global.alvo_selecionado:
		"personagem":
			var textura = Global.imagem_apresentacao_personagem
			var rect = Global.imagem_apresentacao_personagem_propocao
			if typeof(textura) == TYPE_OBJECT and textura is Texture:
				var sprite = $personagem
				sprite.texture = textura
				sprite.region_enabled = true
				sprite.region_rect = rect
			else:
				print("Personagem: textura inválida.")
		
		"token":
			var textura = Global.imagem_apresentacao_token
			var rect = Global.imagem_apresentacao_token_propocao
			if typeof(textura) == TYPE_OBJECT and textura is Texture:
				var sprite = $personagem/token2
				sprite.texture = textura
				sprite.region_enabled = true
				sprite.region_rect = rect
			else:
				print("Token: textura inválida.")
		
		_:
			pass  # nenhum alvo selecionado
