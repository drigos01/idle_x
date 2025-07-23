extends HBoxContainer
func configurar_espaco(enviada_por_mim):
	var espaco = $"espaco - imagem2"  # seu label usado como spacer
	espaco.visible = not enviada_por_mim
