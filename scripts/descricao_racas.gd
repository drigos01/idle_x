extends ColorRect

var comprimento_linha_separadora := 29  # ajuste aqui o tamanho da linha de traços

func repeat_char(char: String, times: int) -> String:
	var result = ""
	for i in range(times):
		result += char
	return result

func pad_end(text: String, length: int) -> String:
	if text.length() >= length:
		return text
	return text + repeat_char(" ", length - text.length())
	
func centered_line(char: String, total_length: int) -> String:
	if total_length < 3:
		return repeat_char(char, total_length)
	var line_length = total_length - 2
	if line_length < 1:
		line_length = 1
	var line = repeat_char(char, line_length)
	var padding = int((total_length - line_length) / 2)
	var espacos_esq = repeat_char(" ", padding)
	var espacos_dir = repeat_char(" ", total_length - line_length - padding)
	return espacos_esq + line + espacos_dir

func word_wrap(text: String, max_line_length: int) -> String:
	var words = text.split(" ")
	var lines = []
	var current_line = ""

	for word in words:
		if current_line == "":
			current_line = word
		elif current_line.length() + 1 + word.length() <= max_line_length:
			current_line += " " + word
		else:
			lines.append(current_line)
			current_line = word
	if current_line != "":
		lines.append(current_line)
	return "\n".join(lines)

func _physics_process(delta: float) -> void:
	if Global.descricao_raca != "":
		var nome_raca = Global.descricao_raca
		if Global.racas.has(nome_raca):
			var dados = Global.racas[nome_raca]

			$nome_raca.text = nome_raca

			# Setar a imagem da raça
			var textura = null
			var caminho_imagem = dados.get("imagem", "")
			#if caminho_imagem != "":
				#textura = load(caminho_imagem)
			#if textura and textura is Texture:
				#$imagem_raca.texture = textura
			#else:
				#$imagem_raca.texture = null  # limpa a textura se não encontrar

			# Descrição com word wrap
			var descricao_node = get_node_or_null("nome_raca/descricao")
			if descricao_node:
				var descricao_raw = dados.get("descricao", "Sem descrição.")
				var max_desc_length = 50  # ajuste conforme o tamanho do seu Label
				descricao_node.text = word_wrap(descricao_raw, max_desc_length)
			else:
				print("Erro: Nó 'nome_raca/descricao' não encontrado!")

			# Atributos e bônus
			var atributos = dados.get("atributos", {})
			var bonus = dados.get("bonus", {})

			# Calcular maior chave para alinhamento
			var todos_chaves = []
			for chave in atributos.keys():
				todos_chaves.append(chave)
			for chave in bonus.keys():
				if not todos_chaves.has(chave):
					todos_chaves.append(chave)
			todos_chaves.sort()

			var max_nome = 0
			for chave in todos_chaves:
				if chave.length() > max_nome:
					max_nome = chave.length()

			var linha_separadora = centered_line("-", comprimento_linha_separadora)

			var texto_atributos = "\n-------- Atributos --------\n"
			for atributo in atributos.keys():
				var nome_formatado = pad_end(atributo.capitalize(), max_nome + 1)
				texto_atributos += "%s: %s\n" % [nome_formatado, str(atributos[atributo])]
			texto_atributos += linha_separadora

			var texto_bonus = "\n---------- Bônus ----------\n"
			for b in bonus.keys():
				var nome_formatado = pad_end(b.capitalize(), max_nome + 1)
				texto_bonus += "%s: +%s\n" % [nome_formatado, str(bonus[b])]
			texto_bonus += linha_separadora

			var combinado_text = texto_atributos + texto_bonus

			$nome_raca/atributos.text = combinado_text.strip_edges(true, true)
	else:
		$nome_raca/atributos.text = ""
		$nome_raca.text = ""
		$nome_raca/descricao.text = ""
		#$imagem_raca.texture = null
		
