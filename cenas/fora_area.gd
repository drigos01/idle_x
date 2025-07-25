extends PanelContainer

func _ready() -> void:
	#if $"..".visible == true:
	Global.mouse_sobre_chat = false
func _on_mouse_entered() -> void:
	print("🖱️ Entrou no chat")
	if $"..".visible == true:
		Global.mouse_sobre_chat = true


func _on_mouse_exited() -> void:
	print("🖱️ Saiu do chat")
	if $"..".visible == true:
		Global.mouse_sobre_chat = false
