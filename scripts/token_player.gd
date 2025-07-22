extends Node

@onready var imagem_original: TextureRect = $imagem_fundo
@onready var imagem_cortada: TextureRect = $borda_token
@onready var borda: TextureRect = $borda_token

func _ready():
	var textura := imagem_original.texture
	if textura == null:
		print("❌ Textura original está vazia.")
		return
	
	var original_img: Image = textura.get_image()
	if original_img == null:
		print("❌ Não foi possível obter a imagem.")
		return
	
	var largura = original_img.get_width()
	var altura = original_img.get_height()
	var lado: int = min(largura, altura)
	var raio: int = lado / 2

	var imagem_circular := Image.create(lado, lado, false, Image.FORMAT_RGBA8)
	imagem_circular.fill(Color(0, 0, 0, 0))  # Transparente

	for y in range(lado):
		for x in range(lado):
			var dx = x - raio
			var dy = y - raio
			if dx * dx + dy * dy <= raio * raio:
				var cor = original_img.get_pixel(x, y)
				imagem_circular.set_pixel(x, y, cor)

	var nova_textura := ImageTexture.create_from_image(imagem_circular)
	imagem_cortada.texture = nova_textura

	# Ajusta tamanho do TextureRect para coincidir com a borda
	imagem_cortada.size = borda.size

	# Posiciona imagem_cortada para ficar exatamente em cima da borda
	imagem_cortada.position = borda.position

	# Mesma stretch mode para manter proporção
	imagem_cortada.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	# Garante visibilidade
	imagem_cortada.visible = true
	borda.visible = true
	imagem_original.visible = false  # se quiser esconder a original

	print("✅ Imagem circular aplicada e alinhada à borda")
