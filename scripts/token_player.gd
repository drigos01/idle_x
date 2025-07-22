extends Sprite2D

@onready var sprite := $icon

func _ready():
	var imagem := Image.new()
	var caminho := "res://imagens/images (1).jpg"
	var erro = imagem.load(caminho)
	#if erro != OK:
		#print("❌ Erro ao carregar imagem:", erro)
		#return
#
	##var textura_cortada = cortar_imagem_com_circulo(imagem, 64)
	#sprite.texture = textura_cortada
#
	#print("✅ Imagem enviada")
	#await get_tree().create_timer(5).timeout
	#Socket.enviar_json("test", {test = "hshdhdd"})
	#print("📤 Enviado")

#func cortar_imagem_com_circulo(imagem: Image, raio: int) -> ImageTexture:
	#var largura := imagem.get_width()
	#var altura := imagem.get_height()
	#var centro := Vector2(largura / 2, altura / 2)
#
	#imagem.lock()
#
	#for y in range(altura):
		#for x in range(largura):
			#var dist = centro.distance_to(Vector2(x, y))
			#if dist > raio:
				#var cor = imagem.get_pixel(x, y)
				#cor.a = 0.0  # Torna transparente
				#imagem.set_pixel(x, y, cor)
#
	#imagem.unlock()
#
	#var textura := ImageTexture.create_from_image(imagem)
	#return textura
