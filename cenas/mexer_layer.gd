extends PanelContainer

# Estados de arraste
var arrastando := false
var pode_arrastar := false
var offset := Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and pode_arrastar:
			arrastando = true
			offset = $"../..".global_position - get_global_mouse_position()
			Global.mouse_sobre_chat = true
		elif not event.pressed:
			arrastando = false
			Global.mouse_sobre_chat = false

	elif event is InputEventMouseMotion and arrastando and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		$"../..".global_position = get_global_mouse_position() + offset
		Global.mouse_sobre_chat = true
		

func _on_mouse_entered() -> void:
	pode_arrastar = true

func _on_mouse_exited() -> void:
	pode_arrastar = false

## Retorna o painel a ser movido (dois níveis acima)
#func get_painel() -> Control:
	#return $"../.."
