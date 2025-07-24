extends Node2D


#var maximizado = true
#func _on_area_chat_area_entered(area: Area2D) -> void:
	#if $".".visible:
		#Global.mouse_sobre_chat = true
	#else:
		#Global.mouse_sobre_chat = false
	#if maximizado:
		#Global.mouse_sobre_chat = true
	#else:
		#Global.mouse_sobre_chat = false
#
#
#func _on_area_chat_area_exited(area: Area2D) -> void:
	#if maximizado:
		#Global.mouse_sobre_chat = false
		#print("falso_inventrario")
	#else:
		#Global.mouse_sobre_chat = false
