extends Area2D
var arrasto = true
func _ready():
	connect("mouse_entered", Callable(self, "_on_area_arastar_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_area_arastar_mouse_exited"))

func _on_area_arastar_mouse_entered() -> void:
	print("🟩 Entrou na área de arrasto")
	arrasto = true

func _on_area_arastar_mouse_exited() -> void:
	print("🟥 Saiu da área de arrasto")
	arrasto = false
