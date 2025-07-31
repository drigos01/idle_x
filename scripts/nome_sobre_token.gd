extends LineEdit

@export var max_font_size := 32
@export var min_font_size := 12
@export var max_text_length := 5
@export var min_scale_factor := 0.4  # nunca diminui menos que isso

var base_scale := Vector2.ONE

func _ready():
	var label = $preview_token/personagem/Label
	if label:
		base_scale = label.scale
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.autowrap_mode = TextServer.AUTOWRAP_OFF

func _process(delta: float) -> void:
	var texto_atual = text.strip_edges()
	var label = $preview_token/personagem/Label

	if not label:
		return

	# Impede digitação além de 20 caracteres
	if texto_atual.length() > 20:
		text = texto_atual.substr(0, 20)
		texto_atual = text
		caret_column = text.length()  # garante que o cursor fique no final


	# Só atualiza o label se o texto mudou
	if texto_atual != label.text:
		label.text = texto_atual

		var length = texto_atual.length()

		var new_size = max_font_size
		if length > max_text_length:
			var excesso = length - max_text_length
			new_size = max_font_size - excesso * 2
			new_size = clamp(new_size, min_font_size, max_font_size)

		var scale_factor = float(new_size) / max_font_size
		scale_factor = max(scale_factor, min_scale_factor)

		label.scale = base_scale * scale_factor
