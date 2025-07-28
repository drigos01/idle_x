extends HBoxContainer


# Called when the node enters the scene tree for the first time.


func start(nick: String, parent):
	$VBoxContainer/nick2.text = nick

	var words_nick = $"VBoxContainer/nick2".text.length()
	var calculate_words = floori((15 - words_nick) / 2)

	for i in calculate_words:
		$"espaco - imagem2".text += " "

	parent.add_child(self)