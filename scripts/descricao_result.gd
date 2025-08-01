extends RichTextLabel

func _process(_delta: float) -> void:
	var nome = Global.raça_selecionado.strip_edges()
	nome = nome.replace(" ", "")
	var regex := RegEx.new()
	regex.compile("[0-9]")
	nome = regex.sub(nome, "", true)

	# Atualiza os atributos com o nome limpo
	Global.raça_selecionado = nome # isso vai disparar o setter e atualizar atributos_completos

	var dados = Global.racas.get(nome, null)
	if not dados:
		self.text = "Raça '" + nome + "' não encontrada."
		return

	var texto = "[b]Raça:[/b] " + nome + "\n\n"
	texto += "[i]" + dados.get("descricao", "") + "[/i]\n\n"

	texto += "[b]Atributos Completos:[/b]\n"
	for chave in Global.atributos_completos.keys():
		texto += "- " + chave.capitalize() + ": " + str(Global.atributos_completos[chave]) + "\n"

	self.text = texto
