extends Panel

var valor_atual: int = 0
var mouse_area_slot = false
func _ready():
	if mouse_area_slot:
		$nome_layer4.text = "Valor: %d" % valor_atual
	else:
		pass

	$mais.connect("pressed", Callable(self, "_on_mais_pressed"))
	$menos.connect("pressed", Callable(self, "_on_menos_pressed"))

func _on_mais_pressed() -> void:
	valor_atual += 1
	$nome_layer4.text = "Valor: %d" % valor_atual

func _on_menos_pressed() -> void:
	valor_atual = max(valor_atual - 1, 0)
	$nome_layer4.text = "Valor: %d" % valor_atual


func _on_panel_container_mouse_entered() -> void:
	mouse_area_slot = true


func _on_panel_container_mouse_exited() -> void:
	mouse_area_slot = false
