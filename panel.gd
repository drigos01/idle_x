extends Panel

var valor_atual: int = 0

var valor_recebido = 0

func _process(delta: float) -> void:
	
	# Inicializa o label com texto original + valor
	$nome_layer.text = "%s: %d" % [$nome_layer.text.get_slice(":", 0), valor_atual]

	# Conectando botões individualmente
	$menos.connect("pressed", Callable(self, "_on_menos_pressed"))
	$mais.connect("pressed", Callable(self, "_on_mais_pressed"))
func _on_menos_pressed() -> void:
	if Global.pontos_usados > 0:
		Global.pontos_usados -= 1
		valor_recebido = Global.valor_total_distribuir_criacao_personagem
		
		valor_atual = max(valor_atual - 1, 0)
		atualizar_label()
	else:
		Global.valor_show_erro_passar = "valor insuficiente"

func _on_mais_pressed() -> void:
	valor_atual += 1
	atualizar_label()

func atualizar_label():
	var texto_original = $nome_layer.text
	if ":" in texto_original:
		texto_original = texto_original.get_slice(":", 0).strip_edges()
	$nome_layer.text = "%s:%d" % [texto_original, valor_atual]
